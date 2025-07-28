import boto3
import os
import json

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get("DYNAMODB_TABLE_NAME", "vpc-provisioning-table")
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        # Get vpc_id from path parameters
        vpc_id = event['pathParameters']['vpc_id']
        
        # Fetch item from DynamoDB
        response = table.get_item(Key={'vpc_id': vpc_id})
        
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': f'VPC ID {vpc_id} not foun'})
            }
        
        return {
            'statusCode': 200,
            'body': json.dumps(response['Item'])
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
