resource "aws_ecs_cluster" "main" {
  name = "${var.conf.prefix}-${var.conf.env}"
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base = var.conf.v.ecs_capacity_providers.fargate.base
    weight = var.conf.v.ecs_capacity_providers.fargate.weight
    capacity_provider = "FARGATE"
  }
  default_capacity_provider_strategy {
    base = var.conf.v.ecs_capacity_providers.fargate_spot.base
    weight = var.conf.v.ecs_capacity_providers.fargate_spot.weight
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_cloudwatch_log_group" "web" {
  name = "/ecs/${var.conf.prefix}-${var.conf.env}/web"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "batch" {
  name = "/ecs/${var.conf.prefix}-${var.conf.env}/batch"
  retention_in_days = 90
}

resource "aws_security_group" "ecs" {
  name = "${var.conf.prefix}-${var.conf.env}-ecs"
  description = "Security group for ${var.conf.prefix}-${var.conf.env}"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [var.conf.v.vpc_cidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-ecs"
  }
}
