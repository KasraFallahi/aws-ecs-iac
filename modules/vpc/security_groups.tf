resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-security-group"
  description = "Security group for ECS services"
  vpc_id      = aws_vpc.main_vpc.id

  # Ingress rules
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_ips
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_ips
  }

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ips
  }

  # Egress rules
  egress {
    description = "Allow outbound traffic to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ecs-security-group"
    Environment = var.environment
  }
}
