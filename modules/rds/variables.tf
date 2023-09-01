variable "conf" {
  type        = any
  description = "values of configuration"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "private subnets for rds subnet group"
}

variable "master_password" {
  type        = string
  description = "db password"
  sensitive = true
}
