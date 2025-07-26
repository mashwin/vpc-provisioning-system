# Signup Lambda
resource "aws_lambda_function" "signup" {
  function_name    = "vpc-provisioning-signup-${var.env}"
  handler          = "main.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("${path.module}/signup.zip")
  filename         = "${path.module}/signup.zip"
  role             = aws_iam_role.lambda_exec.arn
  memory_size      = 128
  timeout          = 300
  environment {
    variables = {
      COGNITO_USER_POOL_ID = var.cognito_user_pool_id
      COGNITO_CLIENT_ID    = var.cognito_app_client_id
    }
  }
}

# IAM Role for Lambda
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

# Basic Lambda logging permissions
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow API Gateway to invoke this Lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/POST/signup" # Least privilege
}
