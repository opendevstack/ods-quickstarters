import uuid

import jinja2
from flask import Flask
from flask_executor import Executor
from flask_httpauth import HTTPBasicAuth

from mlservice.services.infrastructure.logging import read_log


def init_flask():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = str(uuid.uuid4())
    executor = Executor(app)
    auth = HTTPBasicAuth()
    loader = jinja2.ChoiceLoader([
        app.jinja_loader,
        jinja2.FileSystemLoader(['services/training/templates', 'services/prediction/templates']),
    ])
    app.jinja_loader = loader

    @auth.get_password
    def get_password(username):
        if username in app.config['USERS']:
            return app.config['USERS'].get(username)
        return None

    return app, executor, auth


def status() -> str:
    logs = read_log()
    return logs if logs else "Training not started"
