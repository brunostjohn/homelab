terraform {
  required_version = ">= 0.13"

  required_providers {
    radarr = {
      source  = "devopsarr/radarr"
      version = "2.3.0"
    }
  }
}