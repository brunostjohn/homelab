terraform {
  required_version = ">= 0.13"

  required_providers {
    lidarr = {
      source  = "devopsarr/lidarr"
      version = "1.12.0"
    }
  }
}