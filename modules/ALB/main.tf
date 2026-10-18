# ---------------------------------------------------------------
# External ALB (public subnets, both AZs) -> web tier
# ---------------------------------------------------------------
resource "aws_lb" "external" {
  name               = "${var.name_prefix}-ext-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.ex-lb-sg]
  subnets            = var.subnet-public

  tags = { Name = "${var.name_prefix}-ext-alb" }
}

resource "aws_lb_target_group" "web" {
  name                 = "${var.name_prefix}-web-tg"
  port                 = var.web_port
  protocol             = "HTTP"
  vpc_id               = var.vpc-id
  deregistration_delay = 30

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "external_http" {
  load_balancer_arn = aws_lb.external.arn
  port              = var.web_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# ---------------------------------------------------------------
# Internal ALB (private app subnets, both AZs) -> application tier
# ---------------------------------------------------------------
resource "aws_lb" "internal" {
  name               = "${var.name_prefix}-in-lb"
  load_balancer_type = "application"
  internal           = true
  security_groups    = [var.in-lb-sg]
  subnets            = var.subnet-private_app

  tags = { Name = "${var.name_prefix}-in-alb" }
}

resource "aws_lb_target_group" "app" {
  name                 = "${var.name_prefix}-app-tg"
  port                 = var.app_port
  protocol             = "HTTP"
  vpc_id               = var.vpc-id
  deregistration_delay = 30

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = var.web_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
