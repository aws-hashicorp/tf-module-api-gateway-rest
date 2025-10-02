output "rest_api_execution_arn" {
  description = "Execution ARN of the Rest API Gateway."
  value       = aws_api_gateway_rest_api.api_gateway_rest.execution_arn
}

output "rest_api_id" {
  description = "ID of the Rest API Gateway."
  value       = aws_api_gateway_rest_api.api_gateway_rest.id
}

# -------------------------
# outputs API Authorizer
# -------------------------
output "authorizer_id" {
  description = "ID of the API Gateway Rest authorizer."
  value       = one(aws_api_gateway_authorizer.api_authorizer[*].id)
}
