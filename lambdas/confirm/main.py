import boto3
import json
import os

client = boto3.client("cognito-idp")
CLIENT_ID = os.environ["CLIENT_ID"]

def lambda_handler(event, context):
    try:
        body = json.loads(event["body"])
        email = body["email"]
        code = body["code"]

        response = client.confirm_sign_up(
            ClientId=CLIENT_ID,
            Username=email,
            ConfirmationCode=code
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "User confirmed successfully"})
        }

    except client.exceptions.CodeMismatchException:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid confirmation code"})
        }
    except client.exceptions.UserNotFoundException:
        return {
            "statusCode": 404,
            "body": json.dumps({"error": "User not found"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
