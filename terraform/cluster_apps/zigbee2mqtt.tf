resource "kubernetes_namespace" "zigbee2mqtt" {
  metadata {
    name = "zigbee2mqtt"
  }
}

# resource "argocd_application" "zigbee2mqtt" {
#   depends_on = [kubernetes_namespace.zigbee2mqtt]

#   wait = true

#   metadata {
#     name      = "zigbee2mqtt"
#     namespace = "argocd"
#   }

#   spec {
#     project = argocd_project.smarthome.metadata[0].name
#
#     source {
#       repo_url = var.homelab_repo
#       path     = "k8s/zigbee2mqtt"
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = kubernetes_namespace.zigbee2mqtt.metadata[0].name
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