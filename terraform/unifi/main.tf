terraform {
  required_version = ">= 0.13"

  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = "0.41.0"
    }
  }
}

provider "unifi" {
  username       = var.username
  password       = var.password
  api_url        = var.api_url
  site           = var.site
  allow_insecure = true
}