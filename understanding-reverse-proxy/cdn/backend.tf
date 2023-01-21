terraform {
  backend "remote" {
    organization = "spikes"

    workspaces {
      prefix = "cf-reverse-proxy-"
    }
  }
}