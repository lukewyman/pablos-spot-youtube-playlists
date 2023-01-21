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
  type        = string
}

variable "certificate_arn" {
  description = "TLS certificate ARN"
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted zone id"
  type        = string
}

variable "record_names" {
  description = "Endpoint record name"
  type = list(any) 
}

variable "base_domain" {
  type = string 
  description = "Base domain"
}