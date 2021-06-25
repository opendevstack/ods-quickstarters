#!/usr/bin/env python
from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/', methods=['GET'])
def hello_world():
    return jsonify({'msg': 'hello world!'}), 200


# local development ($ python src/main.py)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
