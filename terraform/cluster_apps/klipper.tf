# resource "kubernetes_namespace" "klipper" {
#   metadata {
#     name = "klipper"
#   }
# }

# resource "argocd_application" "klipper" {
#   depends_on = [kubernetes_namespace.klipper]

#   wait = true

#   metadata {
#     name      = "klipper"
#     namespace = "argocd"
#   }

#   spec {
#     source {
#       repo_url = var.homelab_repo
#       path     = "k8s/klipper"
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = kubernetes_namespace.klipper.metadata[0].name
#     }

#     sync_policy {
#       automated {
#         prune     = true
#         self_heal = true
#       }

#       retry {
#         limit = "5"
#         backoff {
#           duration     = "30s"
#           max_duration = "2m"
#           factor       = "2"
#         }
#       }
#     }
#   }
# }