terraform {
  required_version = ">= 0.13"

  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "6.1.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
  }
}