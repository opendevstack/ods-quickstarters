import logging
import sys
from typing import Optional

import invoke
import os
from fabric import Connection

from mlservice.services.infrastructure import git_info
from mlservice.services.infrastructure.environment import dsi_package, http_proxy, https_proxy, \
    nexus_env
from mlservice.services.infrastructure.git_info import GIT_COMMIT
from mlservice.services.infrastructure.remote.ssh.exceptions import RemoteExecutionException


class SSHRemoteExecutor(object):
    """This class enables the remote execution (through a SSH connection) of the
    model.train.train() function

    Attributes
    ----------

    _environment_name: str
        Environment name on the remote machine. It is defined by <repo name>-<branch name>
        (replacing / for -). This name defines the folder where the code is copied to and the
        conda environment name
    _logger: logging.Logger
        Default logger for the class
    _debug_mode: bool
        Enables debug mode during remote execution
    _connection: fabric.Connection
        Default SSH connection used for running the scripts remotely
    _env: dict
        Dictionary of environment variables thar should be used during remote calls
    _home_folder: str
        Remote user home folder
    _python_path: str
        Contains PYTHONPATH=$PYTHONPATH:<remote home folder>/<environment name> for using  it
        during python script execution

    Examples
    --------

    To run the training the following code should be used:

    >>> # New executor instance
    >>> ssh_executor = SSHRemoteExecutor(host= "...", username="...", password="...")
    >>> # Setup all prerequisites for running training
    >>> ssh_executor.setup_prerequisites()
    >>> # Run training
    >>> ssh_executor.run_training()
    >>> # Save model locally
    >>> ssh_executor.save_model_locally()
    """

    def __init__(self, host: str, username: str, password: str, port: int = 22,
                 debug_mode: bool = False, dvc_remote=None) -> None:
        """Initializes the remote executor

        Parameters
        ----------
        host: str
            SSH Host
        username: str
            SSH Username
        password: str
            SSH Password
        port: int
            SSH Port number
        debug_mode: bool
            Enables debug mode during remote execution
        dvc_remote: str, None
            Name of dvc remote that should be used to pull versioned data dependencies

        """

        self._logger = logging.getLogger(__name__)
        self._debug_mode = debug_mode
        self._connection: Connection = Connection(host=host,
                                                  user=username,
                                                  port=port,
                                                  connect_kwargs={
                                                      "password": password
                                                  })

        self._dvc_remote = dvc_remote
        self._dvc_user = username
        self._dvc_password = password

        self._environment_name = "{0}-{1}".format(git_info.GIT_REPO_NAME,
                                                  git_info.GIT_BRANCH.replace("/", "-"))
        self._env: Optional[dict] = None

    def _copy_resources(self) -> None:
        """Copy all resources (code, resources files and binaries) to the remote machine"""

        self._target_folder = "{0}/{1}".format(self._home_folder, self._environment_name)

        self._logger.info(
            "Copying package '{1}' to '{0}' on host...".format(self._target_folder, dsi_package()))

        self._check_exit_code(error_message="Creation and cleanup of target folder failed",
                              result=self._connection.run(
                                  command="""
if [ -d {0} ];
    then rm -r {0}
fi
mkdir {0}""".strip().format(self._target_folder),
                                  hide=not self._debug_mode, warn=True))
        self._connection.put(dsi_package(), self._target_folder)
        self._connection.inline_ssh_env = True
        self._check_exit_code(error_message="Unpacking failed",
                              result=self._connection.run(
                                  command="tar zxf {0}/{1} -C {0}".format(self._target_folder,
                                                                          os.path.basename(
                                                                              dsi_package())),
                                  hide=not self._debug_mode,
                                  warn=True))

        self._logger.info("Copying package to '{0}' on host... Done!".format(self._target_folder))

    def run_training(self) -> None:
        """Runs model.trainer.train() in the remote machine.

        Notes
        -----
            The code that is being executed on the created conda environment. The executions
            works as following:

            Remote script

            $ python src/services/infrastructure/remote/scripts/remote_trainer.py \
            $              --env self._environment_name \
            $              [<if self._debug_mode> --debug]
        """
        # remote training with remote dvc repository
        if self._dvc_remote:
            train_script = """{0}/services/infrastructure/remote/scripts/remote_trainer.py \\
                --env {0} \\
                --debug {1} \\
                --dvc_remote {2} \\
                --dvc_user {3} \\
                --dvc_password {4}""". \
                strip().format(self._target_folder, self._debug_mode, self._dvc_remote,
                               self._dvc_user, self._dvc_password)
        else:
            train_script = """{0}/services/infrastructure/remote/scripts/remote_trainer.py \\
                --env {0} \\
                --debug {1}""".strip().\
                format(self._target_folder, self._debug_mode)

        result = self._connection.run(
            command=self._create_run_script(train_script),
            hide=not self._debug_mode,
            warn=True,
            env=self.env())

        self._check_exit_code(error_message="Training Failed!", result=result)

        for line in result.stderr.strip().splitlines():
            self._logger.info(line)

    def save_model_locally(self) -> None:
        """Saves the remote trained model in the local machine/pod as GIT_COMMIT"""

        model_file = "{0}/{1}/{2}".format(self._home_folder, self._environment_name, GIT_COMMIT)
        self._logger.info("Downloading the model from {0}...".format(model_file))
        self._connection.get(model_file, "/app/{0}".format(os.path.basename(model_file)))
        self._logger.info("Downloading the model from {0}... Done!".format(model_file))

    def setup_prerequisites(self) -> None:
        """Checks and/or setup all pre requisites for running the training remotely

        The prerequisites are:
            * Check connection -> self._check_connection
            * Copy resources -> self._copy_resources
            * Check conda installation
                * Install mini conda if necessary -> self._install_miniconda()
            * Check conda environment with name self._environment_name
                * Create conda environment if needed -> self._create_conda_environment()
            * Updates pip packages in the environment using 'src.requirements.txt' ->
            self._update_pip()

        """
        self._logger.info("Checking pre requisites...")

        self._check_connection()
        self._copy_resources()

        self._logger.info("Checking for conda installation...")

        conda_result: invoke.Result = self._connection.run(command="{0} --version".format(
            self._conda_executable), hide=not self._debug_mode, warn=True, env=self.env())

        if conda_result.exited == 0:
            self._logger.info("Checking for conda installation... Found!")
        else:
            self._logger.info("Checking for conda installation... Not Found!")
            self._install_miniconda()

        self._logger.info("Checking for conda environment...")

        conda_result: invoke.Result = self._connection.run(
            command="source {0}/miniconda/bin/activate {1}".format(self._home_folder,
                                                                   self._environment_name),
            hide=not self._debug_mode,
            warn=True,
            env=self.env())

        if conda_result.exited == 0:
            self._logger.info("Checking for conda environment... Found!")
        else:
            self._logger.info("Checking for conda environment... Not Found!")
            self._create_conda_environment()

        self._update_pip()

        self._logger.info("Checking pre requisites... Done")
        self._logger.info("Ready to start the python scripts!!!")

    def _update_pip(self) -> None:
        """Update the conda environment using `pip install -r src/requirements.txt`.

        If the nexus environment variables NEXUS_URL, NEXUS_USERNAME and NEXUS_PASSWORD are
        available, the nexus server will be used for downloading all python packages
        """

        nexus_url, nexus_username, nexus_password = nexus_env()

        if nexus_url and nexus_username and nexus_password:
            pip_command = "pip install -i https://{0}:{1}@{2}/repository/pypi-all/simple -r"\
                .format(nexus_username, nexus_password, nexus_url[8:])
        else:
            pip_command = "pip install -r"

        self._logger.info("Updating pip packages...")
        activate = "source {0}/miniconda/bin/activate {1}".format(self._home_folder,
                                                                  self._environment_name)
        requirements = " {0}/{1}/requirements.txt".format(self._home_folder, self._environment_name)
        deactivate = "source {0}/miniconda/bin/deactivate".format(self._home_folder)
        self._check_exit_code(error_message="Updating pip packages... Failed!",
                              result=self._connection.run(
                                  command="{0} && "
                                          "{1} {2} && "
                                          "{3}".format(activate,
                                                       pip_command,
                                                       requirements,
                                                       deactivate),
                                  hide=not self._debug_mode,
                                  warn=True,
                                  env=self.env()))

        self._logger.info("Updating pip packages... Done!")

    def _create_conda_environment(self) -> None:
        """Create the conda environment `self._environment_name` in the remote machine"""

        self._logger.info("Creating conda environment '{0}'...".format(self._environment_name))
        self._check_exit_code(error_message="Conda environment was not created!".format(
            self._environment_name), result=self._connection.run(
            command="{0} create --yes --name {1} python={2}.{3}".format(self._conda_executable,
                                                                        self._environment_name,
                                                                        sys.version_info.major,
                                                                        sys.version_info.minor),
            hide=not self._debug_mode, warn=True, replace_env=True, env=self.env()))

        self._logger.info("Creating conda environment '{0}'... Done!".format(
            self._environment_name)
        )

        # install pip in conda
        self._logger.info("Installing pip {} environment...".format(self._environment_name))
        activate = "source {0}/miniconda/bin/activate {1}".format(self._home_folder,
                                                                  self._environment_name)
        install_pip_cmd = "conda install --yes pip"
        deactivate = "source {0}/miniconda/bin/deactivate".format(self._home_folder)
        self._check_exit_code(error_message="Installing pip... Failed!",
                              result=self._connection.run(
                                  command="{0} && "
                                          "{1} && "
                                          "{2}".format(activate,
                                                       install_pip_cmd,
                                                       deactivate),
                                  hide=not self._debug_mode,
                                  warn=True,
                                  env=self.env()))

        self._logger.info("Installing pip {} environment... Done!".format(self._environment_name))

    def env(self, reload=False) -> dict:
        """Creates the dictionary of environment variables used during remote script execution

        Parameters
        ----------
        reload: bool
            Force a reload of all environment variables

        Returns
        -------
        dict

            the returned value contains the proxy setting for the remote machine
            {
                "http_proxy" : "..."
                "https_proxy" : "..."
            }

        """
        if reload or not self._env:
            env = {}

            http_proxy_val = http_proxy()
            https_proxy_val = https_proxy()
            if http_proxy_val:
                env.update({"http_proxy": "{0}".format(http_proxy_val)})
            if https_proxy_val:
                env.update({"https_proxy": "{0}".format(https_proxy_val)})

            self._env = env

        return self._env

    def _install_miniconda(self):
        """Install miniconda on the remote machine inside SSH user home folder. It does not touch
        .bash_profile, .bashrc and other initialization scripts in the user home folder
        """

        miniconda_path = os.getenv("DSI_MINICONDA_PACKAGE_PATH")
        target_miniconda_path = "{0}/{1}".format(self._target_folder,
                                                 os.path.basename(miniconda_path))

        self._logger.info("Installing conda...")

        self._check_exit_code(error_message="Conda installation failed!",
                              result=self._connection.run(
                                  command="bash {0} -b -p $HOME/miniconda".format(
                                      target_miniconda_path),
                                  hide=not self._debug_mode,
                                  warn=True))

        self._logger.info("Installing conda... Done!")

    def _check_exit_code(self, error_message: str, result: invoke.Result) -> None:
        """Check a remote execution result and if the exited code is bigger the 0 (zero) an
        exception will be raised.

        Parameters
        ----------
        error_message: str
            Error message that should be displayed in the exception
        result: invoke.Result
            Remote execution result to be checked

        Raises
        ------
        services.infrastructure.remote.ssh.exceptions.RemoteExecutionException
            this exception represents the error during remote execution and it is raised if
            result.exited > 0

        """
        if result.exited:
            self._logger.error(error_message)
            raise RemoteExecutionException(error_message, result)

    def _create_run_script(self, python_command_line) -> str:
        """Return the script for activating the conda environment, run a python command line and
        deactivate the environment

        The command line looks like:

            $ source <conda_home>/bin/activate <environment> && \
            $   python <python_command_line> && \
            $   source <conda_home>/bin/deactivate


        Parameters
        ----------
        python_command_line: str
            The python command line which should be executed in the form python
            <python_command_line>

        Returns
        -------
        str
            The command line that should be run remotely

        """
        activate = "source {0}/miniconda/bin/activate {1}".format(self._home_folder,
                                                                  self._environment_name)
        deactivate = "source {0}/miniconda/bin/deactivate".format(self._home_folder)

        return "{1} && " \
               '{0} python {2} && ' \
               "{3}".format(self._python_path, activate, python_command_line, deactivate)

    def _check_connection(self) -> None:
        """Checks the remote connection by calling `uname -a` in the remote machine,
        if it succeeds  it reads the $HOME environment variable remotely

        Raises
        ------
        services.infrastructure.remote.ssh.exceptions.RemoteExecutionException
            If the remote user home folder is not proper set ($HOME is empty on the remote machine)

        """
        self._logger.info("Checking connection...")
        self._check_exit_code(error_message="Checking connection... Failed!",
                              result=self._connection.run(
                                  command="uname -a",
                                  hide=not self._debug_mode,
                                  warn=True))

        result: invoke.Result = self._connection.run(
            command="echo $HOME",
            hide=not self._debug_mode,
            warn=True)

        self._home_folder = result.stdout.strip()

        if not self._home_folder:
            raise RemoteExecutionException("Invalid Home Folder in the target host", result)

        self._conda_executable = "{0}/miniconda/bin/conda".format(self._home_folder)
        self._python_path = "PYTHONPATH=$PYTHONPATH:{0}/{1}".format(self._home_folder,
                                                                    self._environment_name)

        self._logger.info("Checking connection... Done!")
