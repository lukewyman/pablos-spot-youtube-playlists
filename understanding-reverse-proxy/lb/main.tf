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
    from_port   = 8080
    to_port     = 8082
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
  for_each          = toset(var.ports_for_target_groups)
  load_balancer_arn = aws_lb.proxy.id
  port              = each.key

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.container[each.key].arn
  }

  tags = local.tags
}