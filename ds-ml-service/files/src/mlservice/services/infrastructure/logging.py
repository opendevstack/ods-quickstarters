import logging
import os
from typing import Optional

from mlservice.services.infrastructure.environment import debug_mode

log_path = None


class FileHandlerFilter(logging.Filter):
    """Log filter for removing all Flask and werkzeug log messages from the logs.
    If debug mode is enabled then the messages will not be filtered out
    """

    def filter(self, record: logging.LogRecord) -> bool:
        return not record.name.startswith(('flask', 'werkzeug')) or debug_mode()


def initialize_logging(path, debug=debug_mode(), remote=False) -> None:
    """Initializes the python's logging factory with a console and a file log handler for all
    log messages

    Parameters
    ----------
    path: str
        Path where the logging.FileHandler should save the log messages
    debug: bool
        Changes the log level from INFO to DEBUG
    remote: bool
        If trues adds a 'REMOTE' to all log messages. Should be true only on the remote
        executable scripts.

    Warnings
    --------
    remote:  Should be true only on the remote executable scripts.


    """
    global log_path

    log_path = path

    log_formatter = logging.Formatter(
        "{0}%(asctime)s [%(name)-15.15s] [%(levelname)-5.5s]  %(message)s".format(
            "|REMOTE| " if remote else "")
    )
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.DEBUG if debug else logging.INFO)

    console_handler = logging.StreamHandler()
    console_handler.setFormatter(log_formatter)
    console_handler.setLevel(logging.DEBUG if debug else logging.INFO)
    root_logger.addHandler(console_handler)

    file_handler = logging.FileHandler(path)
    file_handler.setFormatter(log_formatter)
    file_handler.setLevel(logging.DEBUG)
    file_handler.addFilter(FileHandlerFilter())
    root_logger.addHandler(file_handler)


def read_log() -> Optional[str]:
    """Reads the complete log file

    Returns
    -------
    str
        Log file contents

    """
    global log_path

    if os.path.exists(log_path):
        with open(log_path, 'r') as file:
            return file.read()
    else:
        return None
