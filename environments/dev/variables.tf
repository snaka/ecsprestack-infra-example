variable "db_password" {
  type = string
  description = "db password"
  sensitive = true
}
variable "db_user" {
  type = string
  description = "db user"
  sensitive = true
}
variable "secret_key_base" {
  type = string
  description = "secret key base"
  sensitive = true
}

