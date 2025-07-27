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
