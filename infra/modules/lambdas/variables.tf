variable "env" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "cognito_app_client_id" {
  description = "Cognito App Client ID"
  type        = string
}

variable "api_gateway_execution_arn" {
  description = "Execution ARN of the API Gateway"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of Dynamodb Table"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of Dynamodb Table"
  type        = string
}
