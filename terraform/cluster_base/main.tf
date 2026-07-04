terraform {
  required_version = ">= 0.13"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }

    argocd = {
      source  = "oboukili/argocd"
      version = "7.0.0"
    }
  }
}