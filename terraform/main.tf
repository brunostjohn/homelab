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

    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }

    grafana = {
      source  = "grafana/grafana"
      version = "3.7.0"
    }
  }

  backend "kubernetes" {
    secret_suffix    = "tfstate"
    load_config_file = true
    config_path      = "~/.kube/config"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "argocd" {
  grpc_web    = true
  server_addr = "argocd.${var.global_fqdn}"
  username    = "admin"
  password    = var.argocd_password
}

provider "grafana" {
  url  = "https://grafana.${var.global_fqdn}"
  auth = var.grafana_auth
}