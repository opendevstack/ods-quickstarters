import streamlit as st

from calculation.sample import sample_normal
from plots.histogram import overlay_histograms


st.title("Streamlit Template")
st.header("Sample Normal Distributions")

n_dists = st.selectbox("Number of Distributions", options=[1, 2, 3, 4, 5, 6], index=3)
if n_dists:  # double-checking that selectbox has returned a value
    cols = st.columns(n_dists)

all_samples = []

for i, col in enumerate(cols):
    col.subheader(f"Distribution {i}")
    mean_1 = col.slider(f"Mean {i}", 2, 8, value=2 + i)
    n_samples_1 = col.slider(f"Nr. Samples {i}", 10, 1000, value=500)
    samples = sample_normal(mean_1, 0.5, n_samples_1)
    all_samples.append(samples)

hist_fig = overlay_histograms(*all_samples)
st.plotly_chart(
    hist_fig,
    use_container_width=True,
)
