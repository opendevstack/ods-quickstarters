#!/usr/bin/env python
import argparse
import io
import logging
import os
import traceback

from flask import jsonify, send_file
from flask.templating import render_template

from mlservice.model.trainer import train
from mlservice.services.infrastructure.environment import debug_mode, execution_environment, \
    DSI_EXECUTE_ON_LOCAL, DSI_EXECUTE_ON_SSH, ssh_host, \
    ssh_username, ssh_password, ssh_port, DSI_EXECUTE_ON, training_auth, dvc_remote
from mlservice.services.infrastructure.flask import init_flask, status
from mlservice.services.infrastructure.git_info import GIT_COMMIT, GIT_COMMIT_SHORT, GIT_BRANCH, \
    GIT_LAST_CHANGE, GIT_REPO_NAME
from mlservice.services.infrastructure.logging import initialize_logging
from mlservice.services.infrastructure.remote.ssh.executors import SSHRemoteExecutor

TRAINING_KEY = '_training-job-key_'
"""
Key used for storing the training thread in the executor. It ensures that only one training
instance will run at certain point in time
"""

app, _executor, auth = init_flask()
app.config['USERS'] = training_auth()


@_executor.job
@auth.login_required
def start_training():
    """Starts the training asynchronously using the flask executor

    It runs the training based on the DSI_EXECUTE_ON environment variable and at the end,
    removes the future from the executor
    """
    logging.getLogger(__name__).info("Training execution started...")
    # noinspection PyBroadException
    try:
        environment = execution_environment()
        if environment == DSI_EXECUTE_ON_LOCAL:
            if dvc_remote():
                train(dvc_data_repo=dvc_remote(), dvc_ssh_user=ssh_username(),
                      dvc_ssh_password=ssh_password())
            else:
                train()
        elif environment == DSI_EXECUTE_ON_SSH:
            connection = SSHRemoteExecutor(host=ssh_host(),
                                           username=ssh_username(),
                                           password=ssh_password(),
                                           debug_mode=debug_mode() or flask_args.debug,
                                           port=ssh_port(),
                                           dvc_remote=dvc_remote())

            connection.setup_prerequisites()
            connection.run_training()
            connection.save_model_locally()
        else:
            raise Exception("{0} has a unknown value '{1}'".format(DSI_EXECUTE_ON, environment))

        logging.getLogger(__name__).info("Training execution ended!!!")
    except Exception as training_exc:
        # This exception is broad because we cannot forseen all possible exceptions in
        # the DS train code.
        # Also, since this train is beeing executed in a separed thread all exceptions
        # should be catched
        logging.getLogger(__name__).info("Training execution raised an exception...")
        f = io.StringIO()
        traceback.print_exc(file=f)
        f.seek(0)
        logging.getLogger(__name__).error(f.read())
        raise ValueError(training_exc)


@app.route('/')
@auth.login_required
def get_status():
    """Reports back the training services status"""
    return render_template('index.html',
                           git={
                               'commit': GIT_COMMIT,
                               'commit_short': GIT_COMMIT_SHORT,
                               'branch': GIT_BRANCH,
                               'last_change': GIT_LAST_CHANGE,
                               'name': GIT_REPO_NAME
                           },
                           status=status())


@app.route('/getmodel', methods=['GET'])
@auth.login_required
def get_model():
    """Download the trained model if any or reports 404 when the model is not available"""
    if _executor.futures.running(TRAINING_KEY):
        return jsonify({'error': "Model is not ready"}), 404

    model_path = "{0}".format(GIT_COMMIT)
    if os.path.exists(model_path):
        file = open(model_path, 'rb')
        return send_file(filename_or_fp=file,
                         mimetype="octet-stream",
                         attachment_filename=model_path,
                         as_attachment=True), 200
    else:
        return jsonify({'error': "Model could not be found"}), 404


def response(queued: bool, _status: str = None):
    """Renders the default json answer for the requests

    Parameters
    ----------
    queued: if the job is queued
    _status: text status of the job (Content of the log file)

    HTTP Response
    -------------
        Rendered json with:
        {
            'queued': queued,
            'running': <true if the job is already running>,
            'status': _status
        }
    """
    return jsonify({
        'queued': queued,
        'running': _executor.futures.running(TRAINING_KEY),
        'status': _status
    })


@app.route('/start', methods=['GET'])
@auth.login_required
def start():
    """Request the training to start

    HTTP Response
    -------------
    html
        202: If the training was queued<br/>
        400: If is already a training running

    """
    if _executor.futures.running(TRAINING_KEY):
        return jsonify({'error': 'There is a training job already running'}), 400

    start_training.submit_stored(TRAINING_KEY)
    return response(queued=True), 202


@app.route('/finished', methods=['GET'])
@auth.login_required
def finished():
    """Reports back the status of the training

    HTTP Response
    -------------
    json
        { 'finished': True if finished }

    """
    if _executor.futures.running(TRAINING_KEY):
        return jsonify({'finished': False}), 200
    else:
        training_exc = _executor.futures.exception(TRAINING_KEY)
        _executor.futures.pop(TRAINING_KEY)
        if training_exc:
            return jsonify({'finished': "Training ended with error: {}".format(training_exc)}), 500
        else:
            return jsonify({'finished': True}), 200


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Training model and saving it")
    parser.add_argument("--port", "-p", required=False, default=8080, type=int,
                        help="Port number for the Flask server")
    parser.add_argument("--debug", "-d", action="store_true",
                        help="Enables debug mode in the Flask server")

    flask_args = parser.parse_args()

    initialize_logging("training.log", flask_args.debug)
    app.run('0.0.0.0', flask_args.port, debug=debug_mode() or flask_args.debug)
else:
    initialize_logging(path="training.log", debug=os.getenv('DEBUG', False))
    gunicorn_app = app
