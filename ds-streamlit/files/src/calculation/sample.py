import numpy as np


def sample_normal(mean: float, std: float, n_samples: int) -> np.ndarray:
    """Function for sampling the normal distribution, with given mean
    and standard deviation.

    Args:
        mean (float): mean of the normal distribution
        std (float): standard deviation
        n_samples (int): number of samples to draw

    Returns:
        np.ndarray: containing the drawn samples
    """
    samples = np.random.normal(mean, std, n_samples)
    return samples
