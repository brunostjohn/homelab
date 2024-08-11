variable "argocd_values" {
  type        = string
  description = "Values file for the ArgoCD Helm chart"
}

variable "longhorn_values" {
  type        = string
  description = "Values file for the Longhorn Helm chart"
}

variable "nfs_provisioner_values" {
  type        = string
  description = "Values file for the NFS provisioner Helm chart"
}

variable "akri_values" {
  type        = string
  description = "Values file for the AKRI Helm chart"
}

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

variable "nvidia_plugin_values" {
  type        = string
  description = "Values file for the NVIDIA device plugin Helm chart"
}

variable "cluster_loadbalancer_ip" {
  type        = string
  description = "The desired IP address of the cluster load balancer"
}