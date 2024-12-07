resource "aws_iam_user" "gitlab_user" {
  name = var.user_name
}

resource "aws_iam_user_policy" "ecr_user_policy" {
  name = "${var.user_name}_policy"
  user = aws_iam_user.gitlab_user.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ],
        "Resource" : "${var.ecr_repository_arn}"
      }
    ]
  })
}

resource "aws_iam_access_key" "ecr_user_access_key" {
  user = aws_iam_user.gitlab_user.name
}
