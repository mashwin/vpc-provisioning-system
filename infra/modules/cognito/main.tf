# Cognito User Pool
resource "aws_cognito_user_pool" "users" {
  name = "vpc-provisioning-users-${var.env}"

  # Require email for signup/login
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Password policy
  password_policy {
    minimum_length    = 8
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }
}

# Cognito App Client
resource "aws_cognito_user_pool_client" "web_client" {
  name = "vpc-provisioning-client-${var.env}"

  user_pool_id    = aws_cognito_user_pool.users.id
  generate_secret = false

  # Auth flows
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}
