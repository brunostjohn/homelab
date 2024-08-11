resource "kubernetes_namespace" "adguard" {
  metadata {
    name = "adguard"
  }
}

resource "kubernetes_config_map" "adguard_config" {
  metadata {
    namespace = kubernetes_namespace.adguard.metadata[0].name
    name      = "adguard-config"
  }

  data = {
    "AdGuardHome.yaml" = templatefile("${path.module}/templates/AdGuardHome.yaml.tpl", {
      auth_name = var.adguard_username,
      auth_pass = var.adguard_password
    })
    "username" = var.adguard_username
    "password" = var.adguard_password
  }
}

resource "argocd_application" "adguard" {
  depends_on = [kubernetes_namespace.adguard, kubernetes_config_map.adguard_config]

  metadata {
    name      = "adguard"
    namespace = "argocd"
  }

  wait = true

  spec {
    project = var.networking_project

    source {
      repo_url        = var.homelab_repo
      path            = "k8s/adguard"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.adguard.metadata[0].name
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