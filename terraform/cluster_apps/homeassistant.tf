resource "kubernetes_namespace" "homeassistant" {
  metadata {
    name = "homeassistant"
  }
}

resource "kubernetes_secret" "hassio_token" {
  metadata {
    name      = "hassio-token"
    namespace = kubernetes_namespace.homeassistant.metadata[0].name
  }

  data = {
    "token" = var.hassio_token
  }
}

resource "argocd_application" "homeassistant" {
  depends_on = [kubernetes_namespace.homeassistant]

  wait = true

  metadata {
    name      = "homeassistant"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.smarthome.metadata[0].name

    source {
      repo_url = var.homelab_repo
      path     = "k8s/smarthome/home-assistant"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.homeassistant.metadata[0].name
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