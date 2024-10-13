# resource "argocd_application" "requestrr" {
#   depends_on = [kubernetes_namespace.entertainment]

#   metadata {
#     name      = "requestrr"
#     namespace = "argocd"
#   }

#   spec {
#     project = argocd_project.entertainment.metadata[0].name

#     source {
#       repo_url = var.homelab_repo
#       path     = "k8s/entertainment/requestrr"
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = kubernetes_namespace.entertainment.metadata[0].name
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

# module "requestrr_ingress" {
#   source     = "../ingress"
#   depends_on = [argocd_application.requestrr]

#   service   = "requestrr"
#   hosts     = ["requestrr.local"]
#   namespace = kubernetes_namespace.entertainment.metadata[0].name
#   port      = 4545
# }