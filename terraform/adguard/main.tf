terraform {
  required_version = ">= 0.13"

  required_providers {
    adguard = {
      source  = "gmichels/adguard"
      version = "1.3.0"
    }
  }
}