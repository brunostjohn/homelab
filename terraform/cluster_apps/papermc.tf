resource "argocd_application" "papermc" {
  metadata {
    name      = "papermc"
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "minecraft"
    }

    source {
      repo_url = var.homelab_repo
      path     = "k8s/papermc"

    }

    sync_policy {
      automated {
        self_heal   = true
        prune       = true
        allow_empty = true
      }

      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}

# resource "kubernetes_manifest" "papermc_ingress" {
#   depends_on = [argocd_application.papermc]

#   manifest = {
#     apiVersion = "mc-loadbalancer.brunostjohn.com/v0alpha1"
#     kind       = "MCIngress"

#     metadata = {
#       name      = "papermc"
#       namespace = "minecraft"
#     }

#     spec = {
#       service = "papermc"
#       port    = 25565
#       hosts   = ["cubes.${var.global_fqdn}", "10.0.2.25"]
#     }
#   }
# }