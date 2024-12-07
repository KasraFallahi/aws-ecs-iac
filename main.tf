terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"
}

# IAM Module
module "iam" {
  source             = "./modules/iam"
  user_name          = var.gitlab_iam_user_name
  ecr_repository_arn = module.ecr.ecr_arn
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
}

# ECS Module
module "ecs" {
  source                      = "./modules/ecs"
  vpc_id                      = module.vpc.vpc_id
  subnet_ids                  = module.vpc.subnet_ids
  security_group_ids          = module.vpc.security_group_id
  ecr_repository_url          = module.ecr.ecr_repository_url
  ecs_instance_role_name      = module.iam.ecs_instance_role_name
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}