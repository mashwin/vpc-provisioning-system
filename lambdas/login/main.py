import boto3
import os
import json

client = boto3.client("cognito-idp")

def lambda_handler(event, context):
    try:
        body = json.loads(event["body"])

        username = body.get("username")
        password = body.get("password")

        if not username or not password:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Username and password are required"})
            }

        response = client.initiate_auth(
            AuthFlow="USER_PASSWORD_AUTH",
            AuthParameters={
                "USERNAME": username,
                "PASSWORD": password
            },
            ClientId=os.environ["COGNITO_CLIENT_ID"]
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Login successful",
                "access_token": response["AuthenticationResult"]["AccessToken"]
            })
        }

    except client.exceptions.NotAuthorizedException:
        return {
            "statusCode": 401,
            "body": json.dumps({"message": "Incorrect username or password"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": str(e)})
        }
