
# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "sg_vpc_endpoint" {
  name   = "${var.apigateway_name}-vpc-endpoint-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidrs != null && length(var.allowed_cidrs) > 0 ? [1] : []
    content {
      from_port   = var.sg_listener_port_from
      to_port     = var.sg_listener_port_to
      protocol    = var.sg_listener_protocol
      cidr_blocks = var.allowed_cidrs
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_security_groups != null && length(var.allowed_security_groups) > 0 ? [1] : []
    content {
      from_port       = var.sg_listener_port_from
      to_port         = var.sg_listener_port_to
      protocol        = var.sg_listener_protocol
      security_groups = var.allowed_security_groups
      description     = "Allow from security groups"
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_prefix_list_ids != null && length(var.allowed_prefix_list_ids) > 0 ? [1] : []
    content {
      from_port       = var.sg_listener_port_from
      to_port         = var.sg_listener_port_to
      protocol        = var.sg_listener_protocol
      prefix_list_ids = var.allowed_prefix_list_ids
      description     = "Allow from prefix lists"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.apigateway_name}-vpc-endpoint-sg" })
}

# -------------------------
# VPC Endpoint
# -------------------------
resource "aws_vpc_endpoint" "vpc_endpoint" {
  count               = var.create_vpc_endpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.execute-api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = var.vpc_endpoint_dns_enable

  tags = merge(var.tags, { Name = "vpc-endpoint-${var.apigateway_name}" })
}

# -------------------------
# VPC Endpoint
# -------------------------
resource "aws_vpc_endpoint_policy" "vpc_endpoint_policy" {
  count           = var.create_vpc_endpoint ? 1 : 0
  vpc_endpoint_id = one(aws_vpc_endpoint.vpc_endpoint.id)
  policy          = file("${path.module}/policies/vpc-endpoint_policy.json")
}

# -------------------------
# Create REST API
# -------------------------
resource "aws_api_gateway_rest_api" "api_gateway_rest" {
  name        = var.apigateway_name
  description = "Private Rest API Gateway ${var.apigateway_name}"
  body        = var.api_body_definition

  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.vpc_endpoint.id]
  }

  tags = var.tags
}

# -------------------------
# API Policy
# -------------------------
resource "aws_api_gateway_rest_api_policy" "api_policy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
  policy      = local.api_policy
}

# -------------------------
# API Deployment
# -------------------------
resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest.id
}

# -------------------------
# API Stage
# -------------------------
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest.id
  stage_name    = var.environment

  lifecycle {
    ignore_changes = [deployment_id]
  }
}

# -------------------------
# API Authorizer
# -------------------------
resource "aws_api_gateway_authorizer" "api_authorizer" {
  count           = var.create_authorizer ? 1 : 0
  rest_api_id     = aws_api_gateway_rest_api.api_gateway_rest.id
  name            = var.authorizer_name
  authorizer_uri  = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.authorizer_lambda_arn}/invocations"
  type            = var.authorizer_type
  identity_source = var.identity_source
}
