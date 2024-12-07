resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_ecr_policy" {
  name        = "EcsEcrPolicy"
  description = "IAM policy to allow EC2 instances to interact with ECS and ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecs:UpdateContainerInstancesState",
          "ecs:DiscoverPollEndpoint",
          "ecs:RegisterContainerInstance",
          "ecs:DeregisterContainerInstance",
          "ecs:ListClusters",
          "ecs:ListServices",
          "ecs:ListTasks"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "logs:CreateLogStream"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "logs:PutLogEvents"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = aws_iam_policy.ecs_ecr_policy.arn
}
