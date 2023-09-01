resource "aws_security_group" "main" {
  vpc_id = var.vpc_id
  name   = "${var.conf.prefix}-${var.conf.env}-rds"

  # Allow connect from ECS
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [for az, cidr in var.conf.v.subnets.private : cidr]
  }

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-rds"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.conf.prefix}-${var.conf.env}-rds-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.conf.prefix}-${var.conf.env}-rds-cluster"
  engine_mode        = "serverless"
  engine             = "aurora-mysql"
  engine_version     = "5.7"
  database_name = var.conf.v.rds.database_name
  master_username = var.conf.v.rds.master_username
  master_password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.main.id]

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 2
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}
