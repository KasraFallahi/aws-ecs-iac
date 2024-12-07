output "gitlab_access_key_id" {
  description = "Access key ID for the Gitlab IAM user"
  value       = aws_iam_access_key.ecr_user_access_key.id
}

output "gitlab_secret_access_key" {
  description = "Secret access key for the Gitlab IAM user"
  value       = aws_iam_access_key.ecr_user_access_key.secret
}

output "ecs_instance_role_name" {
  value = aws_iam_role.ecs_instance_role.name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}