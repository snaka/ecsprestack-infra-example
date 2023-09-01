provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment        = module.conf.env
      TerraformWorkspace = terraform.workspace
      Test               = "test2"
    }
  }
}

module "conf" {
  source = "../../modules/conf"
}

resource "aws_ssm_parameter" "secure_string" {
  for_each = {
    db_password = var.db_pass
  }

  name  = "/${module.conf.prefix}/${module.conf.env}/${each.key}"
  type  = "SecureString"
  value = each.value
}

module "vpc" {
  source = "../../modules/vpc"
  conf   = module.conf
}

module "alb" {
  source = "../../modules/alb"
  conf   = module.conf
  vpc    = module.vpc
}

module "ecs" {
  source = "../../modules/ecs"
  conf   = module.conf
  vpc_id = module.vpc.id
}

module "rds" {
  source          = "../../modules/rds"
  conf            = module.conf
  vpc_id          = module.vpc.id
  private_subnets = module.vpc.subnets.private
  master_password = var.db_pass
}
