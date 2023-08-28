variable "conf" {
  type = object({
    prefix = string
    env = string
    account_id = string
    v = any
  })
  description = "Configuration values"
}
