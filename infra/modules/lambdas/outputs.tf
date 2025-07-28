output "signup_arn" {
  value = aws_lambda_function.signup.arn
}

output "login_arn" {
  value = aws_lambda_function.login.arn
}

output "confirm_arn" {
  value = aws_lambda_function.confirm.arn
}

output "createvpc_arn" {
  value = aws_lambda_function.createvpc.arn
}

output "getvpc_arn" {
  value = aws_lambda_function.getvpc.arn
}

output "custom_authorizer_arn" {
  value = aws_lambda_function.custom_authorizer.arn
}

output "custom_authorizer_name" {
  value = aws_lambda_function.custom_authorizer.function_name
}

