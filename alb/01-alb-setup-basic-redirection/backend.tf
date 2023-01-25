terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces {
      prefix = "alb-setup-basic-redirection-"
    }
  }
}