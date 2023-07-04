import plotly.graph_objects as go
import numpy as np

from plots.config import COLOR_PALETTE


def _create_histogram(data_points: np.ndarray, fig: go.Figure, color: str) -> go.Figure:
    """Creates a histogram based on the data samples in *data_points*

    Args:
        data_points (np.ndarray): samples
        fig (plotly.graph_objs._figure.Figure): fig
        color (string): hex code

    Returns:
        plotly.graph_objs._figure.Figure: plotly histogram figure
    """
    fig.add_trace(go.Histogram(x=data_points, marker_color=color))
    return fig


def overlay_histograms(*data_hisograms: np.ndarray) -> go.Figure:
    """Creates histogram overlays.

    Args:
        data_points (np.array): samples of distributions

    Returns:
        plotly.graph_objs._figure.Figure: plotly histogram figure
    """
    fig = go.Figure()
    for i, histo_data in enumerate(data_hisograms):
        fig = _create_histogram(histo_data, fig, COLOR_PALETTE[i])

    fig.update_layout(
        plot_bgcolor="#FFFFFF",  # overwrite streamlit background color in plotly
        template="simple_white",
        xaxis_range=[0, 10],
        barmode="overlay",
    )
    return fig
