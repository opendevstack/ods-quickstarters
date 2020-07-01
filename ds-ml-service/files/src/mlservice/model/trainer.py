import argparse
import logging

import pandas as pd
from sklearn.metrics import accuracy_score

from mlservice.model.model_wrapper import ModelWrapper
from mlservice.services.infrastructure.git_info import GIT_COMMIT
from mlservice.services.infrastructure.remote.dvc.data_sync import DataSync


def train(model_name=GIT_COMMIT, train_data='resources/train.csv', dvc_data_repo=None,
          dvc_ssh_user=None,
          dvc_ssh_password=None):
    """This function is the training entry point and should not be removed. Executes the
    *ModelWrapper.prep_and_train* and saves the model using *joblib*. MANDATORY

    Notes
    -----
    This function can also be used for your local exploration/development. See the
    # >>> if __name__ and "__main__"

    Parameters
    ----------
    model_name : String
        given the trained model a name to store. Default: git_commit id.
    train_data : String
        path where to find the train data.
    dvc_data_repo :  String
    dvc_ssh_user : String
    dvc_ssh_password : String

    Examples
    --------
    In order to pull /optional) dependencies over the integrated data versioning provided by dvc,
    do:
        $ syncer = DataSync(dvc_data_repo, dvc_ssh_user, dvc_ssh_password)
        $ syncer.pull_data_dependency(train_data)
    This will synchronize the dvc data dependencies and training can be conducted
    """
    # where to get the data -> hard coded for now
    data = pd.read_csv(train_data)

    # initiate & train model
    logging.getLogger(__name__).info("Starting classification training...")

    classification_model = ModelWrapper()
    classification_model.prep_and_train(data)
    logging.getLogger(__name__).info("Starting classification training... Done")

    logging.getLogger(__name__).info("Persisting the model...")
    classification_model.save(model_name)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Training model and saving it")
    parser.add_argument("--input", "-i", type=str, help="Input file for training",
                        default="resources/train.csv")
    parser.add_argument("--output", "-o", type=str, help="output model name", default="local")
    parsed_args = parser.parse_args()

    train(model_name=GIT_COMMIT, train_data=parsed_args.input)

    model = ModelWrapper.load(GIT_COMMIT)

    # load test Dataframe
    test_df = pd.read_csv("resources/test.csv")
    print(test_df.to_dict(orient='list'))
    res = model.prep_and_predict(test_df.to_dict(orient='list'))
    print(res, test_df['Species'].values)

    print(accuracy_score(res['prediction'], test_df["Species"].values))
