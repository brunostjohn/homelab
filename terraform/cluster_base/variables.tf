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

variable "proxmox_api_token" {
  type        = string
  description = "The Proxmox API token"
}

variable "personal_email" {
  type        = string
  description = "The personal email address to use for various services"
}

variable "floof_api_key" {
  type        = string
  description = "API key for Floof truenas"
}

variable "klaudia_email" {
  type = string
}

variable "pgadmin_username" {
  type        = string
  description = "The username for the pgAdmin user"
}

variable "pgadmin_password" {
  type        = string
  description = "The password for the pgAdmin user"
}

variable "pg_superuser_password" {
  type        = string
  description = "The password for the PostgreSQL superuser"
}

variable "jabberwock_api_key" {
  type        = string
  description = "The API key for Jabberwock"
}

variable "pg_backup_minio_access_key" {
  type        = string
  description = "The access key for the MinIO instance used for PostgreSQL backups"
}

variable "pg_backup_minio_secret_key" {
  type        = string
  description = "The secret key for the MinIO instance used for PostgreSQL backups"
}

variable "crowdsec_db_password" {
  type        = string
  description = "The password for the CrowdSec database"
}

variable "crowdsec_webhook_url" {
  type        = string
  description = "The webhook URL for CrowdSec"
}

variable "grafana_db_password" {
  type = string
}

variable "second_fqdn" {
  type = string
}

variable "infisical_auth_secret" {
  type = string
}

variable "infisical_encryption_key" {
  type = string
}

variable "infisical_db_password" {
  type = string
}

variable "smtp_host" {
  type        = string
  description = "The SMTP host"
}

variable "smtp_port" {
  type        = number
  description = "The SMTP port"
}

variable "smtp_username" {
  type        = string
  description = "The SMTP username"
}

variable "smtp_password" {
  type        = string
  description = "The SMTP password"
}

variable "smtp_from" {
  type        = string
  description = "The SMTP from address"
}

variable "smtp_use_tls" {
  type        = bool
  description = "Whether to use TLS for SMTP"
}

variable "smtp_use_ssl" {
  type        = bool
  description = "Whether to use SSL for SMTP"
}

variable "infisical_google_client_id" {
  type = string
}

variable "infisical_google_client_secret" {
  type = string
}

variable "infisical_secrets_operator_machine_id" {
  type = string
}

variable "infisical_secrets_operator_machine_secret" {
  type = string
}
