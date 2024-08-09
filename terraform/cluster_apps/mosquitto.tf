resource "kubernetes_namespace" "mosquitto" {
  metadata {
    name = "mosquitto"
  }
}

resource "kubernetes_manifest" "mosquitto_pv" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolume"

    metadata = {
      name = "mosquitto-pv"
    }

    spec = {
      capacity = {
        storage = "1Gi"
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
        volumeHandle = "mosquitto"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mosquitto_pvc" {
  depends_on = [kubernetes_manifest.mosquitto_pv]

  metadata {
    name      = "mosquitto-pvc"
    namespace = kubernetes_namespace.mosquitto.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "longhorn"
    volume_name        = kubernetes_manifest.mosquitto_pv.manifest.metadata.name
  }
}

module "mosquitto_helm" {
  source = "../helm_deployment"

  namespace        = kubernetes_namespace.mosquitto.metadata[0].name
  create_namespace = false

  name            = "mosquitto"
  chart           = "mosquitto"
  repo_url        = "https://storage.googleapis.com/t3n-helm-charts"
  target_revision = "2.4.1"

  create_ingress = false

  values = templatefile("${path.module}/templates/mosquitto.yml.tpl", {
    zigbee2mqtt_password_hash   = var.mqtt_zigbee2mqtt_password_hash
    homeassistant_password_hash = var.mqtt_homeassistant_password_hash
    octoprint_password_hash     = var.mqtt_octoprint_password_hash
    pvc                         = kubernetes_persistent_volume_claim.mosquitto_pvc.metadata[0].name
  })
}