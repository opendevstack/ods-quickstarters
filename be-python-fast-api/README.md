# Python FastAPI Quickstarter (be-python-fast-api)

Documentation is located in our [official documentation](https://www.opendevstack.org/ods-documentation/ods-quickstarters/latest/index.html)

Please update documentation in the [antora page directory](https://github.com/opendevstack/ods-quickstarters/tree/master/docs/modules/ROOT/pages)

Tested thru [automated tests](../tests/be-python-flask)

## Purpose

This Quickstarter creates a Python backend service using [FastAPI](https://fastapi.tiangolo.com/) served by [Uvicorn](https://www.uvicorn.org/). It includes a Helm chart for deployment on OpenShift/Kubernetes.

## Folder structure and important files

- `src/`: Application source code
  - `src/main.py`: FastAPI application entry point with `/` and `/health` endpoints
- `tests/`: Unit tests using pytest and FastAPI's TestClient
- `docker/`: Files for building the container image
  - `docker/Dockerfile`: Container definition (UBI9/Python 3.12 base)
  - `docker/run.sh`: Starts the app with `uvicorn`
- `requirements.txt`: Production dependencies (fastapi, uvicorn)
- `tests_requirements.txt`: Test dependencies (pytest, mypy, flake8, httpx)
- `chart/`: Helm chart for deploying the component
  - `chart/values.yaml`: Default values (resources, probes, service config)
  - `chart/values.dev.yaml`: Overrides for the `dev` environment
  - `chart/values.test.yaml`: Overrides for the `test` environment (2 replicas)
  - `chart/values.prod.yaml`: Overrides for the `prod` environment (2 replicas)

## Testing locally

### Running unit tests

```bash
python3.12 -m venv venv
. venv/bin/activate
pip install -r tests_requirements.txt
PYTHONPATH=src python3.12 -m pytest tests/
```

### Running the application locally

```bash
. venv/bin/activate
PYTHONPATH=src uvicorn main:app --reload --port 8080
```

### Building the container

```bash
cp -r src docker/app
cp requirements.txt docker/app
docker build -t testing/my-component:$(git rev-parse --short=8 HEAD) docker/
```

### Helm chart linting

```bash
helm lint chart/
```

### Helm chart template processing test

```bash
helm --debug template chart/ --set image.path=testing --set image.name=my-component --set image.tag=$(git rev-parse --short=8 HEAD)
```
