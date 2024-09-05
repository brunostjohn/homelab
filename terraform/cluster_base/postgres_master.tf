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
  depends_on = [ argocd_application.nfs_provisioner ]

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