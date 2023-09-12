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
}

module "ssm_parameter" {
  source = "../../modules/ssm_parameter"
  conf   = module.conf
  secrets = {
    "db-password": var.db_password
    "db-user": var.db_user
    "secret-key-base": var.secret_key_base
  }
}
