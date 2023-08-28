data "aws_caller_identity" "current" {}

locals {
  prefix = "example"
  env_root_path = path.root
  env = basename(abspath(local.env_root_path))
  account_id = data.aws_caller_identity.current.account_id

  conf = merge(
    yamldecode(file("${local.env_root_path}/../config.yml")),
    yamldecode(file("${local.env_root_path}/config.yml"))
  )
}
