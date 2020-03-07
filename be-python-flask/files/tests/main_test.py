import main

app = main.app

client = app.test_client()

def test_main_base_endpoint_should_return_hello_world():
    response = client.get('/')

    assert response.status == '200 OK'
    assert response.json['msg'] == 'hello world!'
