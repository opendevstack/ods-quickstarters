import joblib
from sklearn.linear_model import LogisticRegression
import pandas as pd

from mlservice.model.data_cleaning.replace import replace_strings, replace_missing
from mlservice.model.feature_prep.polynomial import add_polynomial


class ModelWrapper(object):
    """Wrap custom models into a common interface that is expected by the training and prediction
    service. Needs to provide MANDATORY functions: PREP_AND_PREDICT as well as TRAIN_AND_PREDICT.

    Example code is showcased on a simple model for the iris flower data set.

    Attributes
    ----------
    model : object
    source_features : list
        contains the names of the source features that are used for training and prediction. Is
        also used to select the features that are posted in the json request
    target_variable : string
        name of the target variable, for training the model
    final_features : list
        contains name of the features that are finally feed to the model, after possible
        feature engineering
    """

    def __init__(self):
        self.model = LogisticRegression()
        self.source_features = ["sepalLength", "sepalWidth", "petalWidth"]
        self.target_variable = "Species"
        self.final_features = []

    def prep_and_predict(self, json_data):
        """Does feature preparation and executes the prediction for *self.model*. MANDATORY

        Parameters
        ----------
        json_data : dict
            json content from the POST. Should at least contain what is specified in
            `self.source_features`.
            Can consume dicts in the form:
             >>> {'feature1': value, ....}
             or
             >>> {'feature1': [value1, value2, ....]}

        Notes
        -----
        Exception is raised if not all `self.source_features` are provided.


        Returns
        -------
        res : dict
            dictionary with the desired json repsonse
        """
        # convert raw json dictionary to dataframe
        try:
            df = pd.DataFrame(json_data)
        except ValueError:
            # in case you have a single value
            df = pd.DataFrame(json_data, index=['0'])

        # restrict to known source features
        try:
            df = df[self.source_features]
        except KeyError:
            raise

        # find all not used source features
        not_used_source = df[df.columns.difference(self.source_features)].columns.values.tolist()
        if not_used_source:
            print("Warning: Features: {} are not being used but given".format(not_used_source))

        # feature preparation
        prep_data_df = self._prep_feature_df(df)
        prep_data = prep_data_df.values

        res = self.model.predict(prep_data).tolist()
        json_res = {"prediction": res}
        return json_res

    def prep_and_train(self, df):
        """Does feature preparation and executes the training for *self.model*. MANDATORY

        Parameters
        ----------
        df : pandas.DataFrame
            DataFrame with training data containing at least *self.source_features* + optionally
            superfluously that will be ignored.

        """
        # prepare features
        source_dataframe = df[self.source_features]
        prep_feature_df = self._prep_feature_df(source_dataframe)

        self.final_features = prep_feature_df.columns
        prep_features = prep_feature_df.values

        # extract target variable
        target = df[self.target_variable].values

        # train
        self.model.fit(prep_features, target)

    def _prep_feature_df(self, df):
        """Executes the feature preparation in succession parsing a DataFrame between ich step.

        Parameters
        ----------
        df : pandas.DataFrame
            containing training or prediction.
        """
        df = df[self.source_features]

        df = replace_missing(df)
        df = replace_strings(df)

        data = add_polynomial(df, "sepalLength", "poly_sepalLength")
        return data

    def save(self, filename):
        """Custom function for saving the `ModelWrapper` instance.

        Notes
        -----
        For this exemplary example, 'joblib' is used to simply dump the instance. However,
        more complicated save scenarios can be thought of, e.g. saving weights of large neural
        network separately, etc....

        Parameters
        ----------
        filename : String
            name of the file to save class instance to
        """
        with open(filename, "wb") as f:
            joblib.dump(self, f)

    @classmethod
    def load(cls, filename):
        """Custom load function for loading an instance of a saved `ModelWrapper`.

        Parameters
        ----------
        filename : String
            name of the saved class instance

        Returns
        -------
        loaded_modelwrapper : ModelWrapper
            loaded instance
        """
        with open(filename, "rb") as f:
            loaded_modelwrapper = joblib.load(f)
            return loaded_modelwrapper
