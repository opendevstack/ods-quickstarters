import logging
import os
from typing import Optional

DSI_DEBUG_MODE = "DSI_DEBUG_MODE"
DSI_PACKAGE = "DSI_PACKAGE"

DSI_EXECUTE_ON = "DSI_EXECUTE_ON"
DSI_EXECUTE_ON_LOCAL = "LOCAL"

DSI_EXECUTE_ON_SSH = "SSH"
DSI_SSH_PASSWORD = "DSI_SSH_PASSWORD"
DSI_SSH_USERNAME = "DSI_SSH_USERNAME"
DSI_SSH_HOST = "DSI_SSH_HOST"
DSI_SSH_PORT = "DSI_SSH_PORT"
DSI_SSH_HTTPS_PROXY = "DSI_SSH_HTTPS_PROXY"
DSI_SSH_HTTP_PROXY = "DSI_SSH_HTTP_PROXY"

DSI_DVC_REMOTE = "DSI_DVC_REMOTE"

NEXUS_USERNAME = "NEXUS_USERNAME"
NEXUS_PASSWORD = "NEXUS_PASSWORD"
NEXUS_URL = "NEXUS_URL"

DSI_TRAINING_SERVICE_USERNAME = "DSI_TRAINING_SERVICE_USERNAME"
DSI_TRAINING_SERVICE_PASSWORD = "DSI_TRAINING_SERVICE_PASSWORD"

DSI_TRAINING_BASE_URL = "DSI_TRAINING_BASE_URL"
DSI_PREDICTION_SERVICE_USERNAME = "DSI_PREDICTION_SERVICE_USERNAME"
DSI_PREDICTION_SERVICE_PASSWORD = "DSI_PREDICTION_SERVICE_PASSWORD"


def debug_mode() -> bool:
    """

    Returns
    -------
    bool
        True if DSI_DEBUG_MODE environment variable is true, 1 or yes

    """
    return os.getenv(DSI_DEBUG_MODE, "false").lower() in ["true",
                                                          "1",
                                                          "yes"]


def execution_environment() -> str:
    """

    Returns
    -------
    str
        Returns DSI_EXECUTE_ON environment variable value or LOCAL if not set

    """
    return os.getenv(DSI_EXECUTE_ON, DSI_EXECUTE_ON_LOCAL).upper()


def ssh_host() -> Optional[str]:
    """

    Returns
    -------
    str
        Returns DSI_SSH_HOST environment variable value

    """
    return os.getenv(DSI_SSH_HOST)


def ssh_username() -> Optional[str]:
    """

    Returns
    -------
    str
        Returns DSI_SSH_USERNAME environment variable value

    """
    return os.getenv(DSI_SSH_USERNAME)


def ssh_password() -> Optional[str]:
    """

    Returns
    -------
    str
        Returns DSI_SSH_PASSWORD environment variable value

    """
    return os.getenv(DSI_SSH_PASSWORD)


def ssh_port() -> int:
    """

    Returns
    -------
    int
        Returns DSI_SSH_PORT environment variable value or 22 if not set

    """
    return int(os.getenv(DSI_SSH_PORT, "22"))


def dvc_remote() -> Optional[str]:
    """Variable indicating, if set that it the data dependencies should be pulled from the
    particular dvc remote repository

    Returns
    -------
    str
        Returns DSI_DVC_REMOTE environment variable value

    """
    return os.getenv(DSI_DVC_REMOTE)


def dsi_package() -> Optional[str]:
    """

    Returns
    -------
    str
        Returns DSI_PACKAGE environment variable value. This variable is set during docker build

    """
    return os.getenv(DSI_PACKAGE)


def http_proxy() -> Optional[str]:
    """

    Returns
    -------
    str
        Returns DSI_SSH_HTTP_PROXY environment variable value

    """
    return os.getenv(DSI_SSH_HTTP_PROXY)


def https_proxy() -> Optional[str]:
    """

    Returns
    -------
    str
        Returns DSI_SSH_HTTPS_PROXY environment variable value

    """
    return os.getenv(DSI_SSH_HTTPS_PROXY)


def nexus_env() -> (Optional[str], Optional[str], Optional[str]):
    """

    Returns
    -------
    str, str, str
        Returns nexus configuration tuple as:
            0 -> Nexus URL (NEXUS_URL environment variable)
            1 -> Nexus username (NEXUS_USERNAME environment variable)
            2 -> Nexus password (NEXUS_PASSWORD environment variable)

        This variables are set during docker build

    """
    return os.getenv(NEXUS_URL), os.getenv(NEXUS_USERNAME), os.getenv(NEXUS_PASSWORD)


def training_host_url() -> str:
    """

    Returns
    -------
    str
        Returns DSI_TRAINING_BASE_URL environment variable value or http://training:8080
        (docker compose url)

    """
    return os.getenv(DSI_TRAINING_BASE_URL, "http://training:8080")


def training_auth() -> dict:
    """

    See Also
    --------
    _auth: See for documentation


    Returns
    -------
    dict
        Returns a dictionary with user authentication parameters based on environment variables as:
        {
            <value of DSI_TRAINING_SERVICE_USERNAME> : <value of DSI_TRAINING_SERVICE_PASSWORD>
        }

    """

    return _auth(DSI_TRAINING_SERVICE_USERNAME, DSI_TRAINING_SERVICE_PASSWORD)


def _auth(username_key: str, password_key: str) -> Optional[dict]:
    """
    Creates username password dictionary based on environment variable names given by
    the parameters. It warns if there is no values for the username and/or password.

    Parameters
    ----------
    username_key: str
        Environment variable for reading username
    password_key: str
        Environment variable for reading password

    Returns
    -------
    dict
        Returns a dictionary with user authentication parameters based on environment variables as:
        {
            <value of username_key environment variable> :
             <value of password_key environment variable>
        }

    """
    user = os.getenv(username_key)
    password = os.getenv(password_key)

    if not user or not password:
        logging.getLogger(__name__).warning("{0} and/or {1} environment variables are not set. "
                                            "This behavior is only accepted during test".
                                            format(username_key, password_key))
        return {}
    else:
        return {
            user: password
        }


def prediction_auth() -> dict:
    """

    See Also
    --------
    _auth: See for documentation


    Returns
    -------
    dict
        Returns a dictionary with user authentication parameters based on environment variables as:
        {
            <value of DSI_PREDICTION_SERVICE_USERNAME> : <value of DSI_PREDICTION_SERVICE_PASSWORD>
        }

    """

    return _auth(DSI_PREDICTION_SERVICE_USERNAME, DSI_PREDICTION_SERVICE_PASSWORD)
