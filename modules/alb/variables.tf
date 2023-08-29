variable "conf" {
  type = object({
    prefix = string
    env = string
    v = any
  })
  description = "values of configuration"
}

variable "vpc" {
  type = any
  description = "VPC resource"
}
