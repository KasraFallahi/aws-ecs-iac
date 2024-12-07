variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "gitlab_iam_user_name" {
  description = "The name of the Gitlab IAM user to be created"
  type        = string
  default     = "gitlab-user"
}
