locals {
  secure_items = [
    "db-user",
    "db-password",
    "secret-key-base",
  ]
}

resource "aws_ssm_parameter" "main" {
  for_each = toset(local.secure_items)

  name  = "/${var.conf.prefix}/${var.conf.env}/${each.value}"
  type = "SecureString"
  value = "dummy" # assume that actual value is stored by web console

  lifecycle {
    ignore_changes = [value, description]
  }
}
