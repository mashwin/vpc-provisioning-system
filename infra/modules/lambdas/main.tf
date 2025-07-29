# signup lambda
resource "aws_lambda_function" "signup" {
  function_name = "vpc-provisioning-signup-${var.env}"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "vpc-provisioning-bucket"
  s3_key        = "lambdas/signup.zip"
  role          = aws_iam_role.lambda_exec.arn
  memory_size   = 128
  timeout       = 300
  environment {
    variables = {
      COGNITO_USER_POOL_ID = var.cognito_user_pool_id
      COGNITO_CLIENT_ID    = var.cognito_app_client_id
    }
  }
}

# iam role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name        = "vpc-provisioning-lambda-role-${var.env}"
  description = "Allows Lambda to call AWS services and write logs"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# basic lambda logging permissions
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# resource policy for signup lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/POST/signup"
}

# login lambda
resource "aws_lambda_function" "login" {
  function_name = "vpc-provisioning-login-${var.env}"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "vpc-provisioning-bucket"
  s3_key        = "lambdas/login.zip"
  role          = aws_iam_role.lambda_exec.arn
  memory_size   = 128
  timeout       = 300
  environment {
    variables = {
      COGNITO_USER_POOL_ID = var.cognito_user_pool_id
      COGNITO_CLIENT_ID    = var.cognito_app_client_id
    }
  }
}

# resource policy for login
resource "aws_lambda_permission" "api_gateway_login" {
  statement_id  = "AllowAPIGatewayInvokeLogin"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/POST/login"
}

# confirm lambda
resource "aws_lambda_function" "confirm" {
  function_name = "vpc-provisioning-confirm-${var.env}"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "vpc-provisioning-bucket"
  s3_key        = "lambdas/confirm.zip"
  role          = aws_iam_role.lambda_exec.arn
  memory_size   = 128
  timeout       = 300
  environment {
    variables = {
      COGNITO_USER_POOL_ID = var.cognito_user_pool_id
      COGNITO_CLIENT_ID    = var.cognito_app_client_id
    }
  }
}

# resource policy for confirm
resource "aws_lambda_permission" "api_gateway_confirm" {
  statement_id  = "AllowAPIGatewayInvokeLogin"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.confirm.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/POST/confirm"
}

# createvpc lambda resource
resource "aws_lambda_function" "createvpc" {
  function_name = "vpc-provisioning-createvpc-${var.env}"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "vpc-provisioning-bucket"
  s3_key        = "lambdas/createvpc.zip"
  role          = aws_iam_role.lambda_exec.arn
  memory_size   = 256
  timeout       = 300

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}

# createvpc lambda permission
resource "aws_lambda_permission" "api_gateway_createvpc" {
  statement_id  = "AllowAPIGatewayInvokeCreateVpc"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.createvpc.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/POST/createvpc"
}


# getvpc resource
resource "aws_lambda_function" "getvpc" {
  function_name = "vpc-provisioning-getvpc-${var.env}"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "vpc-provisioning-bucket"
  s3_key        = "lambdas/getvpc.zip"
  role          = aws_iam_role.lambda_exec.arn
  memory_size   = 256
  timeout       = 300

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}

# getvpc lambda permission
resource "aws_lambda_permission" "api_gateway_getvpc" {
  statement_id  = "AllowAPIGatewayInvokeGetVpc"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getvpc.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/GET/getvpc/*"
}

# custom auth lambda
resource "aws_lambda_function" "custom_authorizer" {
  function_name = "vpc-provisioning-authorizer-${var.env}"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "vpc-provisioning-bucket"
  s3_key        = "lambdas/custom-authorizer.zip"
  role          = aws_iam_role.lambda_exec.arn
  memory_size   = 128
  timeout       = 300
  environment {
    variables = {
      COGNITO_USER_POOL_ID = var.cognito_user_pool_id
      COGNITO_CLIENT_ID    = var.cognito_app_client_id
    }
  }
}


# policy for dynamodb table access
resource "aws_iam_role_policy" "lambda_dynamodb_access" {
  name = "lambda-dynamodb-access"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        Resource = var.dynamodb_table_arn
      }
    ]
  })
}

# policy for creating VPCs and networking resources
resource "aws_iam_role_policy" "lambda_vpc_creation" {
  name = "lambda-vpc-creation"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateVpc",
          "ec2:CreateSubnet",
          "ec2:CreateRouteTable",
          "ec2:CreateRoute",
          "ec2:AssociateRouteTable",
          "ec2:Describe*",
          "ec2:CreateTags"
        ],
        Resource = "*"
      }
    ]
  })
}
