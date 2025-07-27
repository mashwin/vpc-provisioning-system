import boto3
import os
import json
import uuid

ec2 = boto3.client('ec2')
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get("DYNAMODB_TABLE_NAME", "vpc-provisioning-table")

def lambda_handler(event, context):
    try:
        vpc_response = ec2.create_vpc(CidrBlock='10.0.0.0/16')
        vpc_id = vpc_response['Vpc']['VpcId']

        ec2.create_tags(Resources=[vpc_id], Tags=[{'Key': 'Name', 'Value': 'MyVPC'}])

        subnet_response = ec2.create_subnet(
            VpcId=vpc_id,
            CidrBlock='10.0.1.0/24',
            AvailabilityZone=event.get('availabilityZone', 'us-east-1a')
        )
        subnet_id = subnet_response['Subnet']['SubnetId']

        ec2.create_tags(Resources=[subnet_id], Tags=[{'Key': 'Name', 'Value': 'MySubnet'}])

        table = dynamodb.Table(TABLE_NAME)
        table.put_item(Item={
            'vpc_id': vpc_id,
            'subnet_id': subnet_id,
            'region': ec2.meta.region_name
        })

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "VPC and Subnet created",
                "vpcId": vpc_id,
                "subnetId": subnet_id
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": str(e)})
        }