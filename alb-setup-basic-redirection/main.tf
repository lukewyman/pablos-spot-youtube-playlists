resource "aws_lb" "lb" {
  name               = "my-loadbalancer"
  load_balancer_type = "application"
  internal           = false
  subnets            = data.aws_subnets.subnets.ids
}

resource "aws_default_vpc" "default" {

}

# resource "aws_lb_listener" "listener" {
#     load_balancer_arn = aws_lb.lb.arn 
#     port = 443 
#     protocol = "HTTPS"
#     ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
#     certificate_arn = data.aws_acm_certificate.issued.arn 

#     default_action {
#       type = "redirect"

#       redirect {
#         status_code = "HTTP_301"
#         host = "google.com"
#         port = 443 
#         protocol = "HTTPS"
#       }
#     }
# }