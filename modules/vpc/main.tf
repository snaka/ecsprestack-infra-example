resource "aws_vpc" "main" {
  cidr_block = var.conf.v.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}"
  }
}

resource "aws_subnet" "public" {
  for_each = var.conf.v.subnets.public

  vpc_id = aws_vpc.main.id
  availability_zone = each.key
  cidr_block = each.value

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.conf.v.subnets.private

  vpc_id = aws_vpc.main.id
  availability_zone = each.key
  cidr_block = each.value

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-private-${each.key}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}"
  }
}

locals {
  nat_gateway_zones = toset(values(var.conf.v.nat_gateway_zones))
}

resource "aws_eip" "natgw" {
  for_each = local.nat_gateway_zones

  domain = "vpc"

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-${each.key}"
  }
}

resource "aws_nat_gateway" "main" {
  for_each = local.nat_gateway_zones

  allocation_id = aws_eip.natgw[each.key].id
  subnet_id = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.conf.v.subnets.public

  subnet_id = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = var.conf.v.subnets.private

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[var.conf.v.nat_gateway_zones[each.key]].id
  }

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-private-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.conf.v.subnets.private

  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_security_group" "vpc_endpoint" {
  name = "${var.conf.prefix}-${var.conf.env}-vpc-endpoint"
  description = "Allow access to VPC Endpoint"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "services" {
  for_each = toset(
    [
      "ssm",
      "ssmmessages",
      "ecr.api",
      "ecr.dkr",
      # "logs",
      # "ec2messages",
      # "ec2",
      # "kms"
    ]
  )

  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.ap-northeast-1.${each.value}"
  vpc_endpoint_type = "Interface"
  subnet_ids = values(aws_subnet.private)[*].id
  security_group_ids = [aws_security_group.vpc_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-${each.value}"
  }
}
