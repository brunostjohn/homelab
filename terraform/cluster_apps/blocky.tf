resource "kubernetes_namespace" "blocky" {
  metadata {
    name = "blocky"
  }
}

resource "kubernetes_config_map" "blocky" {
  metadata {
    name      = "blocky"
    namespace = kubernetes_namespace.blocky.metadata[0].name
  }

  data = {
    "config.yml" = templatefile("${path.module}/templates/blocky.yml.tpl", {
      global_fqdn = var.global_fqdn
    })
  }
}

resource "argocd_application" "blocky" {
  depends_on = [kubernetes_namespace.blocky, kubernetes_config_map.blocky]

  metadata {
    name      = "blocky"
    namespace = "argocd"
  }

  wait = true

  spec {
    project = var.networking_project

    source {
      repo_url        = var.homelab_repo
      path            = "k8s/blocky"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.blocky.metadata[0].name
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