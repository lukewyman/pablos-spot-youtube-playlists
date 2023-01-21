provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      create_by       = "terraform"
      orchestrated_by = "terragrunt"
      workspace       = "terraform.workspace"
      stack           = "zones-stack"
    }
  }
}