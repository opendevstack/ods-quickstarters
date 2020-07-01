import json
import unittest
from base64 import b64encode

import pandas as pd
from sklearn.metrics import accuracy_score

from mlservice.services.prediction.app import app
from mlservice.services.infrastructure.git_info import GIT_COMMIT

from mlservice.model.model_wrapper import ModelWrapper
#import services.prediction.app as prediction_server

from mlservice.services.infrastructure.remote.dvc.data_sync import DataSync
from mlservice.services.infrastructure.environment import dvc_remote, ssh_username, ssh_password


class TestIntegrationPrediction(unittest.TestCase):

    def setUp(self):
        self.flask_app = app.test_client()

        # Adding users to authenticate against
        self.username = "user"
        self.password = "password"
        app.config['USERS'][self.username] = self.password

        app.config['MODEL'] = ModelWrapper.load(GIT_COMMIT)

        # in case of using data versioning, don't forget to pull test data from remote data repo

        # read held back test data
        self.test_data = pd.read_csv("resources/test.csv")
        self.min_performance = 0.8

        self.predictor = app.config['MODEL']

    def test_accuracy(self):
        # get prediction data
        pred_data = self.test_data[self.predictor.source_features]

        # predict using the prediction endpoint
        predicted_values = []

        for row in pred_data.to_dict(orient="records"):
            response = self.flask_app.post("/predict", data=json.dumps(row),
                                           content_type='application/json', headers={
                    'Authorization': 'Basic {0}'.format(
                        b64encode("{0}:{1}".format(self.username, self.password).encode()).decode())
                })
            res = response.get_json()["prediction"]
            predicted_values.append(res)

        # get accuracy
        accuracy = accuracy_score(predicted_values, self.test_data[
            self.predictor.target_variable].values.tolist())
        print(accuracy)
        self.assertGreaterEqual(accuracy, self.min_performance)
