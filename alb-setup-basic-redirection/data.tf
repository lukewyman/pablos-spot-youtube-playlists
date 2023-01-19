data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
} 

# data "aws_acm_certificate" "issued" {
#     domain = "lukewyman.dev"
#     statuses = ["ISSUED"]
# }