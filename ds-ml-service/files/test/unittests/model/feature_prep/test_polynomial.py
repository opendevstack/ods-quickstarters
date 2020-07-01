import unittest

import pandas as pd

from mlservice.model.feature_prep.polynomial import add_polynomial


class TestPolynomialFeature(unittest.TestCase):

    def test_polynomial(self):
        test_data = {"a": [1, 2, 3]}
        test_data_df = pd.DataFrame(test_data)

        res = add_polynomial(test_data_df, "a", "a**2", 2)
        self.assertListEqual(res["a**2"].values.tolist(), [1, 4, 9])
