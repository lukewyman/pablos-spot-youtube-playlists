resource "aws_lb" "proxy" {
  name               = "lb-web-proxy"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = data.aws_subnet_ids.subnets.ids
  tags               = local.tags
}

resource "aws_security_group" "web_sg" {
  name        = "lb-proxy-sg"
  description = "Load balancer security firewall"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "lb-proxy-securitygroup"
  })
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_lb_target_group" "container" {
  for_each = toset(var.ports_for_target_groups)
  name     = "lb-proxy-target-group-${each.key}"
  port     = each.key
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
  tags     = local.tags
}

resource "aws_lb_target_group_attachment" "target" {
  for_each         = toset(var.ports_for_target_groups)
  target_group_arn = aws_lb_target_group.container[each.key].arn
  target_id        = var.instance_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.proxy.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "Unauthorized"
      status_code = 401
    }
  }
}

resource "aws_route53_record" "endpoint" {
  for_each = toset(var.record_names)
  zone_id = var.hosted_zone_id
  name    = each.key 
  type    = "A"

  alias {
    name = aws_lb.proxy.dns_name 
    zone_id = aws_lb.proxy.zone_id
    evaluate_target_health = true 
  }
}

resource "aws_lb_listener_rule" "radarr_rule" {
  listener_arn = aws_lb_listener.listener.arn 
  priority = 10

  condition {
    host_header {
      values = ["radarr.${var.base_domain}"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.container["8082"].arn 
  }
}

resource "aws_lb_listener_rule" "sonarr_rule" {
  listener_arn = aws_lb_listener.listener.arn 
  priority = 20

  condition {
    host_header {
      values = ["sonarr.${var.base_domain}"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.container["8081"].arn 
  }
}

resource "aws_lb_listener_rule" "blog_rule" {
  listener_arn = aws_lb_listener.listener.arn 
  priority = 30

  condition {
    host_header {
      values = ["main.${var.base_domain}"]
    }
  }

  condition {
    path_pattern {
      values = ["/ghost/*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.container["8080"].arn 
  }
}

resource "aws_lb_listener_rule" "main_rule" {
  listener_arn = aws_lb_listener.listener.arn 
  priority = 40

  condition {
    host_header {
      values = ["main.${var.base_domain}"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.container["8080"].arn 
  }
}