terraform {
  required_version = ">= 0.13"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }

    argocd = {
      source  = "oboukili/argocd"
      version = "7.0.0"
    }
  }
}