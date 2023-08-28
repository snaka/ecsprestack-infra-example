resource "aws_vpc" "main" {
  cidr_block = var.conf.v.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}"
  }
}
