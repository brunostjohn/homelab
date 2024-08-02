resource "kubernetes_ingress_v1" "module_ingress" {
  metadata {
    namespace   = var.namespace
    name        = "${var.service}-ingress"
    annotations = var.annotations
  }

  wait_for_load_balancer = var.wait_for_load_balancer

  spec {
    dynamic "rule" {
      for_each = toset(var.hosts)

      content {
        host = rule.value
        http {
          path {
            backend {
              service {
                name = var.service
                port {
                  number = var.port
                }
              }
            }
          }
        }
      }
    }
  }
}