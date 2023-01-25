resource "aws_lb" "lb" {
    name = "my-loadbalancer"
    load_balancer_type = "application"
    internal = false 
}