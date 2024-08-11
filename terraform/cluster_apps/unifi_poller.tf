resource "kubernetes_secret" "unpoller" {
  metadata {
    name      = "unifi-poller"
    namespace = "monitoring"

    labels = {
      app  = "unifi-poller"
      type = "poller"
    }
  }

  data = {
    "unifi-poller.conf" = templatefile("${path.module}/templates/unifi-poller.conf.tpl", {
      username = var.unifi_username
      password = var.unifi_password
    })
  }
}

resource "argocd_application" "unpoller" {
  depends_on = [kubernetes_secret.unpoller]

  wait = true

  metadata {
    name      = "unpoller"
    namespace = "argocd"
  }

  spec {
    project = var.networking_project

    source {
      repo_url = var.homelab_repo
      path     = "k8s/unifi-poller"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "monitoring"
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