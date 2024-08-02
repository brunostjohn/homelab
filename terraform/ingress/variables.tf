variable "hosts" {
  type        = list(string)
  description = "List of hostnames to route to the service"
}

variable "service" {
  type        = string
  description = "Service name to route traffic to"
}

variable "namespace" {
  type        = string
  description = "Namespace of the service"
}

variable "port" {
  type        = number
  description = "Port of the service"
  default     = 80
}

variable "annotations" {
  type        = map(string)
  description = "Annotations to apply to the Ingress"
  default     = {}
}

variable "wait_for_load_balancer" {
  type        = bool
  description = "Wait for the LoadBalancer to be provisioned"
  default     = true
}