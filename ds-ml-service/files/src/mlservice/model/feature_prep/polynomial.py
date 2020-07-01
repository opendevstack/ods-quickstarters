import numpy as np


def add_polynomial(dataframe, input_col, output_col, power=2):
    """Creates polynomial feature extension that adds newly created features to a DataFrame.
    Example implementation of do feature engineering only creating the powers

    Parameters
    ----------
    dataframe : pandas.DataFrame
    input_col : String
        Name of the column to be mutated.
    output_col : String
        New column name with
    power : int
        the power of the new column

    Returns
    -------
    dataframe : pandas.DataFrame
        DataFrame with newly created column

    """
    dataframe[output_col] = np.power(dataframe[input_col].values, power)
    return dataframe
