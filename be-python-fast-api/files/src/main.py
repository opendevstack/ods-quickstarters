#!/usr/bin/env python
from fastapi import FastAPI

app = FastAPI()


@app.get('/')
def hello_world() -> dict:
    return {'msg': 'hello world!'}


@app.get('/health')
def health() -> dict:
    return {'status': 'ok'}


# local development ($ python src/main.py)
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
