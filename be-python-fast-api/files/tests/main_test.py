from fastapi.testclient import TestClient
import main

client = TestClient(main.app)


def test_main_base_endpoint_should_return_hello_world():
    response = client.get('/')

    assert response.status_code == 200
    assert response.json()['msg'] == 'hello world!'


def test_health_endpoint_should_return_ok():
    response = client.get('/health')

    assert response.status_code == 200
    assert response.json()['status'] == 'ok'
