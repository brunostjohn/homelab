variable "argocd_values" {
  type        = string
  description = "Values file for the ArgoCD Helm chart"
}

variable "longhorn_values" {
  type        = string
  description = "Values file for the Longhorn Helm chart"
}

variable "longhorn_auth_secret" {
  type        = string
  description = "Basic auth secret for Longhorn UI"
}