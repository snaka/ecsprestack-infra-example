output "prefix" {
  value = local.prefix
  description = "Prefix for all resources"
}
output "v" {
  value = local.conf
  description = "Configuration values"
}
output "env" {
  value = local.env
  description = "Environment name"
}
output "account_id" {
  value = local.account_id
  description = "AWS account ID"
}
