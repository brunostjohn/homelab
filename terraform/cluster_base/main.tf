terraform {
  required_version = ">= 0.13"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }

    argocd = {
      source  = "oboukili/argocd"
      version = "6.1.1"
    }
  }
}