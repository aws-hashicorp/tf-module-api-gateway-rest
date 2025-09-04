
locals {
  api_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:apigateway:${var.aws_region}::/restapis/${aws_api_gateway_rest_api.api_gateway_rest.id}/${var.environment}/*/*",
      "Condition": {
        "StringEquals": {
          "aws:sourceVpce": "${aws_vpc_endpoint_policy.vpc_endpoint_policy.*.id}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${one(aws_api_gateway_rest_api.api_gateway_rest.id)}/${var.environment}/*/*"
    }
  ]
}
EOF
}
