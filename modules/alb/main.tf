resource "aws_security_group" "alb" {
  name        = "${var.conf.prefix}-${var.conf.env}-alb"
  description = "Allow inbound traffic from the internet to the ALB"
  vpc_id      = var.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  tags = {
    Name = "${var.conf.prefix}-${var.conf.env}-alb"
  }
}

resource "aws_lb" "web" {
  load_balancer_type = "application"
  name = "${var.conf.prefix}-${var.conf.env}-web"

  idle_timeout = 400
  security_groups = [aws_security_group.alb.id]
  subnets = var.vpc.subnets.public
}

locals {
  hc = var.conf.v.alb.target_group.health_check
}
resource "aws_lb_target_group" "web" {
  name = "${var.conf.prefix}-${var.conf.env}-web"
  vpc_id = var.vpc.id
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  deregistration_delay = 10
  slow_start = 30

  health_check {
    healthy_threshold = local.hc.healthy_threshold
    interval = local.hc.interval
    path = "/"
    port = 3000
    protocol = "HTTP"
    timeout = local.hc.timeout
    unhealthy_threshold = local.hc.unhealthy_threshold
  }
}

resource "aws_lb_listener" "https" {
  port = 443
  protocol = "HTTPS"

  load_balancer_arn = aws_lb.web.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
