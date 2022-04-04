####################################################
# Target Group Creation
####################################################

resource "aws_lb_target_group" "tg" {
  name        = "TargetGroup"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/index.php"
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200-302"
  }
}

resource "aws_lb" "lb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  #subnets            = flatten(["module.vpc.aws_subnet.public_subnet"])
  subnets            = var.subnets
}

####################################################
# Listner
####################################################

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"



  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }


}


####################################################
# Listener Rule
####################################################

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn

  }

  condition {
    path_pattern {
      values = ["/var/www/html/index.php"]
    }
  }
}

output "aws-alb-target-group-arn" {
  value = aws_lb_target_group.tg.arn
}

output "lb_dns_name1" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.lb.dns_name
}