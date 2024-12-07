variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the ECS instances"
  type        = list(string)
}

variable "ecr_repository_url" {
  description = "The URL of the Amazon ECR repository"
  type        = string
}

variable "ecs_instance_role_name" {
  description = "The name of the IAM role to associate with the ECS instances"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "The ARN of the IAM role to associate with the ECS tasks"
  type        = string
}