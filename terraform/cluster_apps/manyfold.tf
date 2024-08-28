resource "kubernetes_namespace" "threedprint" {
  metadata {
    name = "3dprint"
  }
}

resource "kubernetes_secret" "manyfold" {
  metadata {
    name      = "manyfold"
    namespace = kubernetes_namespace.threedprint.metadata[0].name
  }

  data = {
    "secret_key_base" = var.manyfold_secret_key_base
  }
}

resource "argocd_application" "manyfold" {
  depends_on = [kubernetes_secret.manyfold]

  metadata {
    name      = "manyfold"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/manyfold"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.threedprint.metadata[0].name
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
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