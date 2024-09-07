resource "kubernetes_namespace" "pve_exporter" {
  metadata {
    name = "pve-exporter"
  }
}

resource "kubernetes_secret" "pve_exporter" {
  metadata {
    namespace = kubernetes_namespace.pve_exporter.metadata[0].name
    name      = "pve-exporter-config"
  }

  data = {
    "pve.yml" = templatefile("${path.module}/files/pve-exporter.yml.tpl", {
      username = split("!", var.proxmox_api_token)[0]
      token    = split("=", var.proxmox_api_token)[1]
    })
  }
}

resource "argocd_application" "pve_exporter" {
  depends_on = [kubernetes_namespace.pve_exporter, kubernetes_secret.pve_exporter]

  metadata {
    name      = "pve-exporter"
    namespace = "argocd"
  }

  wait = true

  spec {
    project = argocd_project.cluster_mgmt.metadata[0].name

    source {
      repo_url        = argocd_repository.homelab_github.repo
      path            = "k8s/pve-exporter"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.pve_exporter.metadata[0].name
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