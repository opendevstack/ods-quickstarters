import subprocess
import logging


class DataSync(object):
    """Class for managing the data versioning provided by dvc"""

    def __init__(self, remote_repo, user, password):
        """
        Parameters
        ----------
        remote_repo :  string
            specifies the name of the remote dvc repository that was set up. It is the name under
            which the settings of the remote repository is stored in .dvc/config
        user : string
            ssh (technical) user name the service should use to pull the data dependencies
        password : string
            ssh (technical) user password
        """
        self.remote_repo = remote_repo
        self.user = user
        self.password = password

    def _overwrite_dvc_config(self):
        """Overwrites the hardcoded dvc config in the file .dvc/config so that no interactive
        prompt is started.

        Notes
        -----
        Since the .dvc/config contains settings from the user that made the last commit,
        this function first dynamically overwrites the .dvc/config with the technical user account
            1. overwrite the username
            2. deactivate the prompt for password insertion
            3. write the technical account's password in the config
        """
        logging.getLogger(__name__).info(
            "Pulling right data version from remote dvc storage...")
        # add/overwrite technical user in dvc config
        subprocess.check_call(
            ["dvc", "remote", "modify", self.remote_repo, "user", self.user])

        # unset ask for password option to avoid prompt
        subprocess.check_call(["dvc", "remote", "modify", self.remote_repo, "ask_password",
                               "False"])

        # set password
        subprocess.check_call(["dvc", "remote", "modify", self.remote_repo, "password",
                               self.password])

    def pull_all_data_dependencies(self):
        """Pulls all data dependencies from remote ssh dvc repository."""
        self._overwrite_dvc_config()

        # checkout dvc pull files according to git checkout
        subprocess.check_call(["dvc", "pull", "-r", self.remote_repo])
        logging.getLogger(__name__).info("Pulling right data version from remote dvc storage...  "
                                         "Done")

    def pull_data_dependency(self, remote_file):
        """Pulls specific data dependencies from remote ssh dvc repository.

        Parameters
        ----------
            remote_file : String
                file name of the data dependency that should be pulled from remote
        """
        self._overwrite_dvc_config()

        # checkout dvc pull file according to git checkout
        subprocess.check_call(["dvc", "pull", "-r", self.remote_repo,
                               "{0}.dvc".format(remote_file)])
        logging.getLogger(__name__).info("Pulling right data version of file {0} from remote dvc "
                                         "storage... Done".format(remote_file))
