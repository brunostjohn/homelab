resource "kubernetes_namespace" "authentik" {
  metadata {
    name = "authentik"
  }
}

resource "kubernetes_manifest" "authentik_postgres" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolume"

    metadata = {
      name = "authentik-postgres-pv"
    }

    spec = {
      capacity = {
        storage = "10Gi"
      }
      volumeMode                    = "Filesystem"
      accessModes                   = ["ReadWriteOnce"]
      persistentVolumeReclaimPolicy = "Retain"
      storageClassName              = "longhorn"

      csi = {
        driver = "driver.longhorn.io"
        fsType = "ext4"
        volumeAttributes = {
          numberOfReplicas    = "3"
          staleReplicaTimeout = "30"
        }
        volumeHandle = "authentik-postgres"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "authentik_postgres" {
  depends_on = [kubernetes_manifest.authentik_postgres]

  metadata {
    name      = "authentik-postgres-pvc"
    namespace = kubernetes_namespace.authentik.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = "longhorn"
    volume_name        = kubernetes_manifest.authentik_postgres.manifest.metadata.name
  }
}

resource "argocd_application" "authentik" {
  depends_on = [kubernetes_namespace.authentik, kubernetes_persistent_volume_claim.authentik_postgres]

  wait = true

  metadata {
    name      = "authentik"
    namespace = "argocd"
  }

  spec {
    project = var.security_project

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.authentik.metadata[0].name
    }

    source {
      repo_url        = "https://charts.goauthentik.io"
      chart           = "authentik"
      target_revision = "2024.6.1"

      helm {
        values = templatefile("${path.module}/templates/authentik.yml.tpl", {
          secret_key        = var.authentik_secret_key,
          postgres_password = var.authentik_postgres_password,
          global_fqdn       = var.global_fqdn,
          smtp_host         = var.smtp_host,
          smtp_port         = var.smtp_port,
          smtp_username     = var.smtp_username,
          smtp_password     = var.smtp_password,
          smtp_from         = var.smtp_from,
          smtp_use_tls      = var.smtp_use_tls,
          smtp_use_ssl      = var.smtp_use_ssl
        })
      }
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