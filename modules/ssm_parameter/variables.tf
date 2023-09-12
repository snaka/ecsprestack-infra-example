variable "conf" {
  type        = any
  description = "values of configuration"
}

variable "secrets" {
  type = map(string)
  description = "secret values"
}
