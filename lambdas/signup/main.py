import os
import json
import boto3

# Env vars
CLIENT_ID = os.environ.get("COGNITO_CLIENT_ID")

# Init client
cognito_client = boto3.client("cognito-idp")

def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))
        username = body.get("email")
        password = body.get("password")

        if not username or not password:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing email or password"})
            }

        response = cognito_client.sign_up(
            ClientId=CLIENT_ID,
            Username=username,
            Password=password,
            UserAttributes=[
                {
                    "Name": "email",
                    "Value": username
                }
            ]
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Signup successful",
                "userSub": response["UserSub"]
            })
        }

    except cognito_client.exceptions.UsernameExistsException:
        return {
            "statusCode": 409,
            "body": json.dumps({"error": "User already exists"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
