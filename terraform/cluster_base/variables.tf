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