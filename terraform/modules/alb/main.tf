############### ALB Target Group ###############

resource "aws_lb_target_group" "alb_target_group" {
  name        = var.tg_name
  port        = var.tg_port
  protocol    = var.tg_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = var.tg_protocol
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.tg_name
  }
}

###############  ALB ###############
resource "aws_lb" "alb" {
  name               = "${var.environment}-wp-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = var.alb_security_groups
  subnets         = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.environment}-wp-alb"
  }
}

############### ALB Listener ###############
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
