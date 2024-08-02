module "ingress" {
  count  = var.create_ingress ? 1 : 0
  source = "../ingress"

  hosts                  = var.hosts
  service                = var.service_name
  namespace              = var.namespace
  wait_for_load_balancer = true
  port                   = var.service_port
  annotations            = var.ingress_annotations
}