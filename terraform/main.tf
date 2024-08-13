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

provider "grafana" {
  url  = "http://grafana.${var.global_fqdn}"
  auth = var.grafana_auth
}

provider "cloudflare" {
  api_token = var.provider_cloudflare_api_token
}

provider "prowlarr" {
  url     = "http://prowlarr.local"
  api_key = var.prowlarr_api_key
}

provider "radarr" {
  url     = "http://radarr.local"
  api_key = var.radarr_api_key
}

provider "sonarr" {
  url     = "http://sonarr.local"
  api_key = var.sonarr_api_key
}

provider "readarr" {
  url     = "http://readarr.local"
  api_key = var.readarr_api_key
}

provider "lidarr" {
  url     = "http://lidarr.local"
  api_key = var.lidarr_api_key
}