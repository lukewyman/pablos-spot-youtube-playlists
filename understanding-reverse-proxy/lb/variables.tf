variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-west-2"
}

variable "ports_for_target_groups" {
  type    = list(string)
  default = ["8080", "8081", "8082"]
}

variable "instance_id" {
  description = "Target ec2 instance id"
  type = string 
}