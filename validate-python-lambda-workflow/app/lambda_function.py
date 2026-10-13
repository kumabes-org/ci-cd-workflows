import json

from src.say_hello import SayHello


def lambda_handler(event, context):
    name = 'kumabes-org'
    if event and 'name' in event:
        name = event['name']
    result = SayHello().say_english(name)
    message = {
        'message': result,
        'status_code': 200
    }
    return json.dumps(message)
