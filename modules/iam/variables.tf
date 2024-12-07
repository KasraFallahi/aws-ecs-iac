variable "user_name" {
  description = "Name of the IAM user to create"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository the user will access"
  type        = string
}