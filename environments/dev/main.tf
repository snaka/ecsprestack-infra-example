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
