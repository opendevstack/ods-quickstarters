import dash
from dash.dependencies import Input, Output, State
import dash_core_components as dcc
import dash_html_components as html
import numpy as np

app = dash.Dash(__name__)

app.layout = html.Div([
    dcc.Store(id='store', data=[]),
    dcc.Interval(id='auto-refresh', interval=1000, n_intervals=0),
    html.Button(id='reset', children='Reset'),
    dcc.Graph(id='graph')
])


@app.callback(
    Output('store', 'data'),
    [Input('auto-refresh', 'n_intervals'), Input('reset', 'n_clicks')],
    [State('store', 'data')]
)
def update_data(n_intervals, n_clicks, existing_data):
    ctx = dash.callback_context
    if 'reset' in ctx.triggered[0]['prop_id']:
        return np.random.randn(5)
    return existing_data + np.random.randn(5).tolist()


@app.callback(Output('graph', 'figure'), [Input('store', 'data')])
def update_figure(data):
    return {'data': [{'y': data, 'type': 'bar'}]}


if __name__ == '__main__':
    app.run_server(host='0.0.0.0', debug=True, port=8080)
