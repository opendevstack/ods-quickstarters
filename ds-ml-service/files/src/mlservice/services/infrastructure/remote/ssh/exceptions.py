from invoke import Result


class RemoteExecutionException(Exception):
    """Exception that is raised when a remote execution fails"""

    def __init__(self, message: str, result: Result):
        """

        Parameters
        ----------
        message: str
            Message to be displayed
        result: invoke.Result
            The result of the remote call for being printed
        """
        super(RemoteExecutionException, self).__init__()
        self.message = message
        self.remote_result = result

    def __str__(self):
        return """{message}
CMD: {remote_result.command}
Exit Code: {remote_result.exited}

### stdout ###
{remote_result.stdout}
### stderr ###
{remote_result.stderr}
##############""".format(message=self.message, remote_result=self.remote_result)
