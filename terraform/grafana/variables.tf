variable "client_id" {
  type        = string
  description = "The OIDC client ID for Grafana"
}

variable "client_secret" {
  type        = string
  description = "The OIDC client secret for Grafana"
}

variable "global_fqdn" {
  type        = string
  description = "The global FQDN for the homelab"
}

variable "personal_email" {
  type        = string
  description = "The email address of the person deploying the homelab"
}