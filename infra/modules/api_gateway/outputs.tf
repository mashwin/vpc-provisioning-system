output "invoke_url" {
  description = "API Gateway invoke URL"
  value       = "${aws_api_gateway_deployment.vpc_api_gateway_deployment.invoke_url}/${aws_api_gateway_stage.vpc_api_gateway_stage.stage_name}"
}

output "execution_arn" {
  description = "API Gateway execution ARN"
  value       = aws_api_gateway_rest_api.vpc_provisioning_api.execution_arn
}
