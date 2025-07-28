import json

def lambda_handler(event, context):
    headers = event.get('headers', {})
    token = headers.get('Authorization')

    print(f"Headers: {headers}")
    print(f"Authorization Token: {token}")

    method_arn = event.get('methodArn')

    if token == "allow":
        return generate_policy("user", "Allow", method_arn)
    else:
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
