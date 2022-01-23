resource "aws_lb" "public" {
  name               = "roboshop-public-${var.ENV}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-alb.id]
  subnets            = data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNETS_IDS

  enable_deletion_protection = false

  tags = {
    Environment = "roboshop-public-${var.ENV}"
  }
}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ok"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "frontend-public" {
  zone_id = data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTEDZONE_ID
  name    = "roboshop_${var.ENV}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.public.dns_name]
}