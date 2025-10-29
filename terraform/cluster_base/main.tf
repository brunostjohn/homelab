terraform {
  required_version = ">= 0.13"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.0"
    }

    argocd = {
      source  = "oboukili/argocd"
      version = "7.0.0"
    }
  }
}