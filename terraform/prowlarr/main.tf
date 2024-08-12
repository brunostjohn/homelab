terraform {
  required_version = ">= 0.13"

  required_providers {
    prowlarr = {
      source  = "devopsarr/prowlarr"
      version = "2.4.2"
    }
  }
}