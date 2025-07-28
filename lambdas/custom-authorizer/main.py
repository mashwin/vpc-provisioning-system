import json
import os
import boto3
from botocore.exceptions import ClientError

client = boto3.client('cognito-idp')

USER_POOL_ID = os.environ.get("COGNITO_USER_POOL_ID")
APP_CLIENT_ID = os.environ.get("COGNITO_APP_CLIENT_ID")

def lambda_handler(event, context):
    headers = event.get('headers', {})
    token = headers.get('Authorization')

    print(f"Headers: {headers}")
    print(f"Authorization Token: {token}")

    method_arn = event.get('methodArn')

    if not token:
        return generate_policy("user", "Deny", method_arn)

    try:
        # Validate token
        response = client.get_user(AccessToken=token)
        print(f"Cognito Response: {response}")

        return generate_policy("user", "Allow", method_arn)
    except ClientError as e:
        print(f"Token validation failed: {e}")
        return generate_policy("user", "Deny", method_arn)

def generate_policy(principal_id, effect, resource):
    if effect and resource:
        return {
            "principalId": principal_id,
            "policyDocument": {
                "Version": "2012-10-17",
                "Statement": [{
                    "Action": "execute-api:Invoke",
                    "Effect": effect,
                    "Resource": resource
                }]
            }
        }
