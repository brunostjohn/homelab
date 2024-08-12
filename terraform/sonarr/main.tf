terraform {
  required_version = ">= 0.13"

  required_providers {
    sonarr = {
      source  = "devopsarr/sonarr"
      version = "3.2.0"
    }
  }
}