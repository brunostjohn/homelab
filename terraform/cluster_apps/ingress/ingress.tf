resource "kubernetes_ingress_v1" "module_ingress" {
  metadata {
    namespace = var.namespace
    name      = "${var.service}-ingress"
  }

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