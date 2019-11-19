def replace_missing(dataframe):
    """Stupid example implementation of removing missing values and replacing them with a 0

    Parameters
    ----------
    dataframe : pandas.DataFrame
        Input DataFrame

    Returns
    -------
    dataframe : pandas.DataFrame
        Output DataFrame
    """
    return dataframe.fillna(0)


def replace_strings(dataframe):
    """Stupid example implementation of removing invalid characters and replacing them with a 0

    Parameters
    ----------
    dataframe : pandas.DataFrame
        Input DataFrame

    Returns
    -------
    dataframe : pandas.DataFrame
        Output DataFrame
    """
    return dataframe.replace("xx", 0)
