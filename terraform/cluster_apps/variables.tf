variable "homelab_repo" {
  type        = string
  description = "The URL of the homelab repository"
}

variable "adguard_username" {
  type        = string
  description = "adguard username"
}

variable "adguard_password" {
  type        = string
  description = "adguard password"
}

variable "k8s_dashboard_values" {
  type        = string
  description = "The values file for the k8s dashboard"
}

variable "k8s_dashboard_token" {
  type        = string
  description = "The token for the k8s dashboard"
}