terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces {
      prefix = "zones-reverse-proxy-"
    }
  }
}