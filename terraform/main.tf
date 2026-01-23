terraform {
  required_version = ">= 0.13"

  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "7.0.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }

    grafana = {
      source  = "grafana/grafana"
      version = "4.25.0"
    }

    infisical = {
      source  = "Infisical/infisical"
      version = "0.15.59"
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

data "infisical_secrets" "cluster" {
  env_slug     = "dev"
  folder_path  = "/"
  workspace_id = var.infisical_workspace_id
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "argocd" {
  grpc_web    = true
  server_addr = "argocd.${data.infisical_secrets.cluster.secrets["global_fqdn"].value}"
  username    = "admin"
  password    = data.infisical_secrets.cluster.secrets["argocd_password"].value
}

provider "grafana" {
  url  = "https://grafana.${data.infisical_secrets.cluster.secrets["global_fqdn"].value}"
  auth = data.infisical_secrets.cluster.secrets["grafana_auth"].value
}

provider "infisical" {
  host          = "https://secrets.${var.global_fqdn}"
  client_id     = var.infisical_client_id
  client_secret = var.infisical_client_secret
}