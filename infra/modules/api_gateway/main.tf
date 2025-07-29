# api gateway resource
resource "aws_api_gateway_rest_api" "vpc_provisioning_api" {
  name        = "vpc-provisioning-api"
  description = "API for VPC provisioning"
}

# signup resource
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

# signup lambda integration
resource "aws_api_gateway_integration" "signup_lambda" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id = aws_api_gateway_resource.signup.id
  http_method = aws_api_gateway_method.signup_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.signup_lambda_arn}/invocations"
}

# login resource
resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_provisioning_api.root_resource_id
  path_part   = "login"
}

# post method for login
resource "aws_api_gateway_method" "login_post" {
  rest_api_id   = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"
}

# login lambda integration
resource "aws_api_gateway_integration" "login_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.login_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.login_lambda_arn}/invocations"
}

# confirm resource
resource "aws_api_gateway_resource" "confirm" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_provisioning_api.root_resource_id
  path_part   = "confirm"
}

# post method for confirm
resource "aws_api_gateway_method" "confirm_post" {
  rest_api_id   = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id   = aws_api_gateway_resource.confirm.id
  http_method   = "POST"
  authorization = "NONE"
}

# confirm lambda integration
resource "aws_api_gateway_integration" "confirm_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id             = aws_api_gateway_resource.confirm.id
  http_method             = aws_api_gateway_method.confirm_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.confirm_lambda_arn}/invocations"
}

# createvpc resource
resource "aws_api_gateway_resource" "createvpc" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_provisioning_api.root_resource_id
  path_part   = "createvpc"
}

# post method for createvpc
resource "aws_api_gateway_method" "createvpc_post" {
  rest_api_id      = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id      = aws_api_gateway_resource.createvpc.id
  http_method      = "POST"
  authorization    = "CUSTOM"
  authorizer_id    = aws_api_gateway_authorizer.vpc_authorizer.id
  api_key_required = false
  request_parameters = {
    "method.request.header.Authorization" = true
  }
}

# createvpc lambda integration
resource "aws_api_gateway_integration" "createvpc_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id             = aws_api_gateway_resource.createvpc.id
  http_method             = aws_api_gateway_method.createvpc_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.createvpc_lambda_arn}/invocations"
}

# resource for getvpc
resource "aws_api_gateway_resource" "getvpc" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  parent_id   = aws_api_gateway_rest_api.vpc_provisioning_api.root_resource_id
  path_part   = "getvpc"
}

# resource for getvpc/{vpc_id}
resource "aws_api_gateway_resource" "getvpc_by_id" {
  rest_api_id = aws_api_gateway_rest_api.vpc_provisioning_api.id
  parent_id   = aws_api_gateway_resource.getvpc.id
  path_part   = "{vpc_id}"
}

# GET method for getvpc
resource "aws_api_gateway_method" "getvpc_by_id_get" {
  rest_api_id      = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id      = aws_api_gateway_resource.getvpc_by_id.id
  http_method      = "GET"
  authorization    = "CUSTOM"
  authorizer_id    = aws_api_gateway_authorizer.vpc_authorizer.id
  api_key_required = false
  request_parameters = {
    "method.request.path.vpc_id"          = true
    "method.request.header.Authorization" = true
  }
}

# Lambda integration for getvpc
resource "aws_api_gateway_integration" "getvpc_by_id_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.vpc_provisioning_api.id
  resource_id             = aws_api_gateway_resource.getvpc_by_id.id
  http_method             = aws_api_gateway_method.getvpc_by_id_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.getvpc_lambda_arn}/invocations"
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

  # Forces a new deployment on every `apply`
  triggers = {
    redeployment = timestamp()
  }
  #   stage_name  = "dev"
  depends_on = [
    aws_api_gateway_method.signup_post,
    aws_api_gateway_integration.signup_lambda,
    aws_api_gateway_method.login_post,
    aws_api_gateway_integration.login_lambda,
    aws_api_gateway_method.confirm_post,
    aws_api_gateway_integration.confirm_lambda,
    aws_api_gateway_method.createvpc_post,
    aws_api_gateway_integration.createvpc_lambda,
    aws_api_gateway_method.getvpc_by_id_get,
    aws_api_gateway_integration.getvpc_by_id_lambda,
  ]
}

# Lambda permission to allow API Gateway to invoke authorizer
resource "aws_lambda_permission" "api_gateway_invoke_authorizer" {
  statement_id  = "AllowAPIGatewayInvokeCustomAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = var.custom_authorizer_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vpc_provisioning_api.execution_arn}/*"
}

# API Gateway Custom Authorizer
resource "aws_api_gateway_authorizer" "vpc_authorizer" {
  name                             = "vpc-authorizer-${var.env}"
  rest_api_id                      = aws_api_gateway_rest_api.vpc_provisioning_api.id
  authorizer_uri                   = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.custom_authorizer_arn}/invocations"
  authorizer_result_ttl_in_seconds = 0
  identity_source                  = "method.request.header.Authorization"
  type                             = "REQUEST"
}
