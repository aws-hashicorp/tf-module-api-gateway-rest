# --- Global Variables ---
variable "environment" {
  description = "The environment for the ECS service"
  type        = string
  default     = "dev"
}

variable "account_id" {
  description = "The AWS account id"
  type        = number
  default     = 0
}

variable "aws_region" {
  description = "The AWS region where the ECS service will be deployed"
  type        = string
}

variable "apigateway_name" {
  description = "The name of the API Gateway"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
  default     = []
}

# --- Security Group Variables ---
variable "allowed_cidrs" {
  description = "The CIDR blocks to allow"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "The security groups to allow"
  type        = list(string)
  default     = []
}

variable "allowed_prefix_list_ids" {
  description = "The prefix list IDs to allow"
  type        = list(string)
  default     = []
}

variable "sg_listener_port_from" {
  description = "The starting port for the security group listener"
  type        = number
  default     = 443
}

variable "sg_listener_port_to" {
  description = "The ending port for the security group listener"
  type        = number
  default     = 443
}

variable "sg_listener_protocol" {
  description = "The protocol for the security group listener"
  type        = string
  default     = "tcp"
}

# --- VPC Endpoint Variables ---
variable "create_vpc_endpoint" {
  description = "Flag to create the VPC endpoint"
  type        = bool
  default     = true
}

variable "vpc_endpoint_dns_enable" {
  description = "Whether to create a DNS entry for the VPC endpoint"
  type        = bool
  default     = true
}

# -------------------------
# API Definition Variables
# -------------------------
variable "api_body_definition" {
  description = "Body definition for the HTTP API"
  type        = string
  default     = ""
}

# -------------------------
# Authorizer Variables
# -------------------------
variable "create_authorizer" {
  description = "Flag to create the authorizer"
  type        = bool
  default     = true
}

variable "authorizer_name" {
  description = "Name of the authorizer"
  type        = string
  default     = ""
}

variable "authorizer_lambda_arn" {
  description = "ARN of the Lambda function used as the authorizer"
  type        = string
  default     = ""
}

variable "authorizer_type" {
  description = "The type of authorizer for API Gateway (e.g., REQUEST or JWT)"
  type        = string
  default     = ""
}

variable "identity_source" {
  description = "List of identity sources for the authorizer"
  type        = string
  default     = "string"
}

# -------------------------
# API Policy Variables
# -------------------------
variable "api_policy" {
  description = "The policy document for the API Gateway"
  type        = string
  default     = ""
}

# -------------------------
# API Key Variables
# -------------------------
variable "create_api_key" {
  description = "Flag to create the authorizer"
  type        = bool
  default     = false
}

