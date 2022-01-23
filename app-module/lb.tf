resource "aws_lb_target_group" "tg" {
  name     = local.tags["Name"]
  port     = var.PORT
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 5
    path                = "/health"
    unhealthy_threshold = 2
    timeout             = 4
  }
}

resource "aws_lb_target_group_attachment" "tg-attach" {
  count            = length(local.INSTANCE_IDS)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(local.INSTANCE_IDS, count.index)
  port             = var.PORT
}

resource "aws_lb_listener_rule" "private" {
  count        = var.IS_PRIVATE_LB ? 1 : 0
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = var.LB_RULE_PRIORITY

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.rooshop.internal"]
    }
  }
}

resource "aws_lb_listener_rule" "public" {
  count        = var.IS_PRIVATE_LB ? 1 : 0
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = var.LB_RULE_PRIORITY

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.rooshop.internal"]
    }
  }
}

resource "aws_lb_listener" "private-listener-http" {
  count             = var.IS_PRIVATE_LB ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "private-listener-https" {
  count             = var.IS_PRIVATE_LB ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = "80"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "public-listener-http" {
  count             = var.IS_PRIVATE_LB ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener" "public-listener-https" {
  count             = var.IS_PRIVATE_LB ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = ""
  certificate_arn   = "arn:aws:acm:us-east-1:260038077524:certificate/9b89d405-b479-4e56-bf81-3744bc990c9f"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

}


