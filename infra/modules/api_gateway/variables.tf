# variable "lambda_arns" {
#   description = "ARNs of Lambda functions"
#   type        = map(string)
# }

# variable "cognito_user_pool_arn" {
#   description = "ARN of Cognito User Pool"
#   type        = string
# }


variable "signup_lambda_arn" {
  description = "ARN of the signup Lambda function"
  type        = string
}

variable "login_lambda_arn" {
  description = "ARN of the login lambda function"
  type        = string
}

variable "confirm_lambda_arn" {
  description = "ARN of the confirm lambda function"
  type        = string
}

variable "createvpc_lambda_arn" {
  description = "ARN of the createvpc lambda function"
  type        = string
}

variable "getvpc_lambda_arn" {
  description = "ARN of the getvpc lambda function"
  type        = string
}

variable "custom_authorizer_arn" {
  description = "ARN of the getvpc lambda function"
  type        = string
}

variable "custom_authorizer_name" {
  description = "ARN of the getvpc lambda function"
  type        = string
}

variable "region" {
  description = "default region"
  default     = "us-east-1"
}

variable "env" {
  description = "default env"
  default     = "dev"
}
