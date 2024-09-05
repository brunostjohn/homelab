variable "global_fqdn" {
  type        = string
  description = "The global FQDN for the homelab"
}

variable "alertmanager_discord_webhook_url" {
  type        = string
  description = "The Discord webhook URL for Alertmanager"
}

variable "crowdsec_enroll_key" {
  type        = string
  description = "The CrowdSec enrollment key"
}

variable "crowdsec_bouncer_key_traefik" {
  type        = string
  description = "The CrowdSec Traefik bouncer key"
}

variable "letsencrypt_email" {
  type        = string
  description = "The email address to use for Let's Encrypt"
}

variable "letsencrypt_cloudflare_api_token" {
  type        = string
  description = "The Cloudflare API token to use for Let's Encrypt DNS-01 challenges"
}

variable "cluster_loadbalancer_ip" {
  type        = string
  description = "The desired IP address of the cluster load balancer"
}

variable "cloudflare_ddns_api_token" {
  type        = string
  description = "The Cloudflare API token for the Cloudflare DDNS service"
}

variable "argocd_oidc_client_id" {
  type        = string
  description = "The OIDC client ID for ArgoCD"
}

variable "argocd_oidc_client_secret" {
  type        = string
  description = "The OIDC client secret for ArgoCD"
}

variable "proxmox_service_account_username" {
  type        = string
  description = "The username of the service account to use for Proxmox"
}

variable "proxmox_service_account_password" {
  type        = string
  description = "The password of the service account to use for Proxmox"
}

variable "personal_email" {
  type = string
  description = "The personal email address to use for various services"
}