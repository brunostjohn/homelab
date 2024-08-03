terraform {
  required_version = ">= 0.13"

  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "6.1.1"
    }

    unifi = {
      source  = "paultyng/unifi"
      version = "0.41.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

    adguard = {
      source  = "gmichels/adguard"
      version = "1.3.0"
    }

    authentik = {
      source  = "goauthentik/authentik"
      version = "2024.6.1"
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
  server_addr = "argocd.local"
  insecure    = true
  username    = "admin"
  password    = var.argocd_password
}

provider "docker" {
  host     = "ssh://brunostjohn@10.0.0.2:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

provider "unifi" {
  username       = var.unifi_username
  password       = var.unifi_password
  api_url        = var.unifi_api_url
  site           = var.unifi_site
  allow_insecure = true
}

provider "adguard" {
  host     = var.adguard_host
  username = var.adguard_username
  password = var.adguard_password
  scheme   = var.adguard_scheme
}

provider "authentik" {
  url   = "https://auth.${var.global_fqdn}"
  token = var.authentik_token
}