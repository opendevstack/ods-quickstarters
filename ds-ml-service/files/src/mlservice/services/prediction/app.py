import argparse
import os

from flask import jsonify, request

from mlservice.services.infrastructure.environment import training_host_url, debug_mode
from mlservice.services.infrastructure.flask import init_flask
from mlservice.services.infrastructure.git_info import GIT_COMMIT

from mlservice.services.infrastructure.logging import initialize_logging
from mlservice.services.infrastructure.environment import prediction_auth

from mlservice.model.model_wrapper import ModelWrapper

# initialize flask application
TRAINING_POD_URL = training_host_url()
app, _executor, auth = init_flask()
app.config['USERS'] = prediction_auth()
app.config["MODEL"] = ModelWrapper.load(GIT_COMMIT)


@app.route('/predict', methods=['POST'])
@auth.login_required
def predict():
    """Provides the endpoint for getting new predictions from the developed model using a POST
    request json.

    HTTP Request Parameters
    -----------------------
    data : json
        Json post containing at least the *ModelWrapper.source_features*. Otherwise a error will
        be thrown

    HTTP Response
    -------------
    pred_json : json
        Response sent back by the service containing the predicted label/value in the format:
        { prediction : label/value}

    """
    # read json submitted with POST
    data = request.get_json(silent=True)

    # logging received data
    app.logger.info(data)

    # predict new value including feature prep
    try:
        res = app.config["MODEL"].prep_and_predict(data)
        return jsonify(res)
    except KeyError as e:
        msg = 'Problem with the provided json post: {0}'.format(e)
        app.logger.error(msg)
        resp = jsonify({'error': msg})
        resp.status_code = 400
        return resp


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Training model and saving it")
    parser.add_argument("--port", "-p", required=False, default=8080, type=int,
                        help="Port number for the Flask server")
    parser.add_argument("--debug", "-d", action="store_true",
                        help="Enables debug mode in the Flask server")
    parser.add_argument("--local", "-l", required=False, default=False, type=bool,
                        help="setting dummy user name and password for local development")

    flask_args = parser.parse_args()

    initialize_logging("prediction.log")

    if flask_args.local:
        username = "user"
        password = "password"
        app.config['USERS'][username] = password

    app.run('0.0.0.0', flask_args.port, debug=debug_mode() or flask_args.debug)
else:
    initialize_logging(path="prediction.log", debug=os.getenv('DEBUG', False))
    gunicorn_app = app
