resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "ecs-template"
  image_id      = "ami-00d72ec36cdfc8a0a" # Amazon Linux 2 AMI(for eu-central-1)
  instance_type = "t3.nano"

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    name = var.ecs_instance_role_name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs.sh")
}
