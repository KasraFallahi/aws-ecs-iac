resource "aws_ecr_repository" "zurutech_ecr" {
  name = var.ecr_repository_name

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}

#  Policy for cleaning up old images
resource "aws_ecr_lifecycle_policy" "image_policy" {
  repository = aws_ecr_repository.zurutech_ecr.name

  policy = file("${path.module}/lifecycle-policy.json")

  depends_on = [aws_ecr_repository.zurutech_ecr]
}