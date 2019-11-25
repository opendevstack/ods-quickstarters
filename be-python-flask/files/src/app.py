#!/usr/bin/env python
from flask import Flask
from flask.templating import render_template

app = Flask(__name__)


@app.route('/')
def hello():
    return render_template('base.html')


app.run('0.0.0.0', 8080, debug=True)
