import json


def handler(event, context):
    response = {}
    response['headers'] = {}
    response['headers']['statusCode'] = 200
    response['headers']['Content-Type'] = 'applicaton/json'

    response['body'] = json.dumps('Hello from AWS Lambda!')

    return response