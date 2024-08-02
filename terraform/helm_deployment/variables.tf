variable "namespace" {
  type        = string
  description = "Namespace of the service"
}

variable "create_namespace" {
  type        = bool
  description = "Create the namespace if it does not exist"
  default     = false
}

variable "create_ingress" {
  type        = bool
  description = "Create the ingress"
  default     = true
}

variable "hosts" {
  type        = list(string)
  description = "List of hostnames to route to the service"
  default     = []
}

variable "service_name" {
  type        = string
  description = "Service name to route traffic to"
  default     = ""
}

variable "name" {
  type        = string
  description = "application name"
}

variable "repo_url" {
  type        = string
  description = "repository url"
}

variable "chart" {
  type        = string
  description = "chart name"
}

variable "target_revision" {
  type        = string
  description = "chart version"
}

variable "values" {
  type        = string
  description = "values file"
  default     = ""
}

variable "service_port" {
  type        = number
  description = "Port of the service"
  default     = 80
}

variable "ingress_annotations" {
  type        = map(string)
  description = "Annotations to apply to the Ingress"
  default     = {}
}