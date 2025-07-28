import boto3
import json

client = boto3.client('cognito-idp')

def lambda_handler(event, context):
    headers = event.get('headers', {})
    token = headers.get('Authorization') or headers.get('authorization')

    print(f"All headers: {headers}")
    print(f"Extracted token: {token}")

    method_arn = event.get('methodArn')

    if not token:
        print("No token found")
        return generate_policy("user", "Deny", method_arn)

    try:
        response = client.get_user(AccessToken=token)
        print(f"Cognito user: {response}")
        return generate_policy("user", "Allow", method_arn)
    except client.exceptions.NotAuthorizedException as e:
        print(f"Invalid token: {e}")
        return generate_policy("user", "Deny", method_arn)
    except Exception as e:
        print(f"Unexpected error: {e}")
        return generate_policy("user", "Deny", method_arn)

def generate_policy(principal_id, effect, resource):
    return {
        "principalId": principal_id,
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": effect,
                    "Resource": resource
                }
            ]
        }
    }
