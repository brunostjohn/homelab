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