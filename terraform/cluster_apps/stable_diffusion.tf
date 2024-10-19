# resource "argocd_application" "stable_diffusion" {
#   metadata {
#     name      = "stable-diffusion"
#     namespace = "argocd"
#   }

#   spec {
#     source {
#       repo_url = var.homelab_repo
#       path     = "k8s/stable-diffusion"
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = kubernetes_namespace.ai.metadata[0].name
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
