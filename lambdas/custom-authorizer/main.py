import json

def lambda_handler(event, context):
    print("=== Custom Authorizer Invoked ===")
    print("Authorization Token:", event.get('authorizationToken'))
    print("Method ARN:", event.get('methodArn'))

    token = event.get('authorizationToken')
    method_arn = event.get('methodArn')

    if token == "allow":
        print("✔ Token matched 'allow'. Returning Allow policy.")
        return generate_policy("user", "Allow", method_arn)
    else:
        print("❌ Token did NOT match. Returning Deny policy.")
        return generate_policy("user", "Deny", method_arn)

def generate_policy(principal_id, effect, resource):
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
