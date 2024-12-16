variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "allowed_http_ips" {
  description = "List of CIDR blocks allowed for HTTP traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Adjust for production.
}

variable "allowed_https_ips" {
  description = "List of CIDR blocks allowed for HTTPS traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Adjust for production.
}

variable "admin_ips" {
  description = "List of CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = [] # Add specific IP ranges for admins.
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "prod"
    Project = "aws-ecs-iac"
  }
}
