resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
}

resource "kubernetes_manifest" "postgres_pv" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolume"

    metadata = {
      name = "master-postgres-pv"
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
        volumeHandle = "global-postgres-master"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres" {
  depends_on = [kubernetes_manifest.postgres_pv]

  metadata {
    name      = "master-postgres-pvc"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = "longhorn"
    volume_name        = kubernetes_manifest.postgres_pv.manifest.metadata.name
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_backup" {
  depends_on = [argocd_application.nfs_provisioner]

  metadata {
    name      = "postgres-backup-pvc"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "50Gi"
      }
    }
    storage_class_name = "nfs-jabberwock-subpath"
  }
}

module "cloudnative_pg" {
  # depends_on = [  ]
  source = "../helm_deployment"

  namespace        = kubernetes_namespace.databases.metadata[0].name
  name             = "cloudnative-pg"
  create_namespace = false
  create_ingress   = false

  chart             = "cloudnative-pg"
  repo_url          = "https://cloudnative-pg.github.io/charts"
  target_revision   = "0.22.0"
  values            = file("${path.module}/values/cloudnative-pg.yml")
  server_side_apply = true
}

resource "kubernetes_secret" "pgadmin_secrets" {
  metadata {
    name      = "postgres-cluster-pgadmin4"
    namespace = "databases"
  }

  data = {
    username = var.pgadmin_username
    password = var.pgadmin_password
  }
}

resource "kubernetes_secret" "pg_superuser" {
  metadata {
    name      = "postgres-cluster-superuser"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  type = "kubernetes.io/basic-auth"

  data = {
    username = "postgres"
    password = var.pg_superuser_password
  }
}

resource "kubernetes_secret" "pg_backup_minio" {
  metadata {
    name      = "postgres-cluster-backup-minio"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  data = {
    "MINIO_ACCESS_KEY" = var.pg_backup_minio_access_key
    "MINIO_SECRET_KEY" = var.pg_backup_minio_secret_key
  }
}

resource "argocd_application" "postgres" {
  depends_on = [
    module.cloudnative_pg,
    kubernetes_secret.pgadmin_secrets,
    kubernetes_secret.pg_superuser,
    kubernetes_secret.pg_backup_minio,
    kubernetes_manifest.selfsigned_issuer
  ]

  metadata {
    name      = "postgres-cluster"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url        = argocd_repository.homelab_github.repo
      path            = "k8s/postgres"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.databases.metadata[0].name
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

module "postgres" {
  depends_on = [kubernetes_persistent_volume_claim.postgres, kubernetes_persistent_volume_claim.postgres_backup]

  source           = "../helm_deployment"
  namespace        = kubernetes_namespace.databases.metadata[0].name
  name             = "postgres"
  create_namespace = false
  create_ingress   = false

  chart           = "postgresql"
  repo_url        = "https://charts.bitnami.com/bitnami"
  target_revision = "15.5.21"
  values          = file("${path.module}/values/postgres.yml")
}