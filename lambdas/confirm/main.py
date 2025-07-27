import boto3
import json
import os

client = boto3.client("cognito-idp")
print("os environ ", os.environ)
CLIENT_ID = os.environ["COGNITO_CLIENT_ID"]

def lambda_handler(event, context):
    try:
        body = json.loads(event["body"])
        email = body["email"]
        code = body["code"]

        print("email", email, code)
        print("client id ", CLIENT_ID)

        response = client.confirm_sign_up(
            ClientId=CLIENT_ID,
            Username=email,
            ConfirmationCode=code
        )

        print("response ", response)

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
