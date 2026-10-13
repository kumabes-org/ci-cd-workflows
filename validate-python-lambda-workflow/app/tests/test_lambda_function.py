import json

import lambda_function


def test_lambda_handler():
    event = {'name': 'Alice'}
    context = None
    
    response = json.loads(lambda_function.lambda_handler(event, context))
    assert response['message'] == "Hello world, Alice!"
    assert response['status_code'] == 200
    