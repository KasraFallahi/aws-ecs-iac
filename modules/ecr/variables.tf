variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "zurutech-repo"
}

variable "environment" {
  description = "Environment tag for the ECR repository"
  type        = string
  default     = "development"
}