module "cognito" {
  source = "./modules/cognito"
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  signup_lambda_arn    = module.lambdas.signup_arn
  login_lambda_arn     = module.lambdas.login_arn
  confirm_lambda_arn   = module.lambdas.confirm_arn
  createvpc_lambda_arn = module.lambdas.createvpc_arn
}

module "lambdas" {
  source                    = "./modules/lambdas"
  env                       = "dev"
  cognito_user_pool_id      = module.cognito.user_pool_id
  cognito_app_client_id     = module.cognito.app_client_id
  api_gateway_execution_arn = module.api_gateway.execution_arn
  dynamodb_table_arn        = module.dynamodb.dynamodb_table_arn
  dynamodb_table_name       = module.dynamodb.dynamodb_table_name
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "vpc-provisioning-table"
}
