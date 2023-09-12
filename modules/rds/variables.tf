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

variable "db_password" {
  type = string
  sensitive = true
  description = "master password"
}
