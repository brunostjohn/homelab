terraform {
  required_version = ">= 0.13"

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2024.8.4"
    }
  }
}