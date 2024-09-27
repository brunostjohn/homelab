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

    authentik = {
      source  = "goauthentik/authentik"
      version = "2024.8.4"
    }

    grafana = {
      source  = "grafana/grafana"
      version = "3.7.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    prowlarr = {
      source  = "devopsarr/prowlarr"
      version = "2.4.2"
    }

    radarr = {
      source  = "devopsarr/radarr"
      version = "2.2.0"
    }

    sonarr = {
      source  = "devopsarr/sonarr"
      version = "3.2.0"
    }

    readarr = {
      source  = "devopsarr/readarr"
      version = "2.1.0"
    }

    lidarr = {
      source  = "devopsarr/lidarr"
      version = "1.12.0"
    }

    proxmox = {
      source  = "bpg/proxmox"
      version = "0.62.0"
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

provider "unifi" {
  username       = var.unifi_username
  password       = var.unifi_password
  api_url        = var.unifi_api_url
  site           = var.unifi_site
  allow_insecure = true
}

provider "authentik" {
  url   = "https://auth.${var.global_fqdn}"
  token = var.authentik_token
}

provider "grafana" {
  url  = "http://grafana.${var.global_fqdn}"
  auth = var.grafana_auth
}

provider "cloudflare" {
  api_token = var.provider_cloudflare_api_token
}

provider "prowlarr" {
  url     = "https://prowlarr.${var.global_fqdn}"
  api_key = var.prowlarr_api_key
}

provider "radarr" {
  url     = "https://radarr.${var.global_fqdn}"
  api_key = var.radarr_api_key
}

provider "sonarr" {
  url     = "https://sonarr.${var.global_fqdn}"
  api_key = var.sonarr_api_key
}

provider "readarr" {
  url     = "https://readarr.${var.global_fqdn}"
  api_key = var.readarr_api_key
}

provider "lidarr" {
  url     = "https://lidarr.${var.global_fqdn}"
  api_key = var.lidarr_api_key
}

provider "proxmox" {
  endpoint  = "https://${var.proxmox_s1_ip}:8006/"
  insecure  = true
  api_token = var.proxmox_api_token
}