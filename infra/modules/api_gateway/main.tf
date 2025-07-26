resource "aws_api_gateway_rest_api" "vpc_provisioning_api" {
  name        = "vpc-provisioning-api"
  description = "API for VPC provisioning"
}

# Signup resource
resource "aws_api_gateway_resource" "signup" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_provisioning_api.root_resource_id
  path_part   = "signup"
}

# POST method for /signup
resource "aws_api_gateway_method" "signup_post" {
  rest_api_id   = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id   = aws_api_gateway_resource.signup.id
  http_method   = "POST"
  authorization = "NONE"
}

# Link to Lambda
resource "aws_api_gateway_integration" "signup_lambda" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id = aws_api_gateway_resource.signup.id
  http_method = aws_api_gateway_method.signup_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.signup_lambda_arn}/invocations"
}

# Stage
resource "aws_api_gateway_stage" "vpc_api_gateway_stage" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.vpc_provisioning_api.id
  deployment_id = aws_api_gateway_deployment.vpc_api_gateway_deployment.id

  lifecycle {
    create_before_destroy = true
  }
}

# Deployment
resource "aws_api_gateway_deployment" "vpc_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id

  triggers = {
    redeployment = timestamp() # Forces a new deployment on every `apply`
  }
  #   stage_name  = "dev"
  depends_on = [
    aws_api_gateway_method.signup_post,
    aws_api_gateway_integration.signup_lambda
  ]
}
