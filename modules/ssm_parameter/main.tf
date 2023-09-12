resource "aws_ssm_parameter" "main" {
  for_each = var.secrets

  name  = "/${var.conf.prefix}/${var.conf.env}/${each.key}"
  type = "SecureString"
  value = each.value
}
