output "user_pool_id" {
  value = aws_cognito_user_pool.users.id
}

output "app_client_id" {
  value = aws_cognito_user_pool_client.web_client.id
}
