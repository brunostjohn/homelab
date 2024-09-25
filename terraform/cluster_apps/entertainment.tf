resource "kubernetes_persistent_volume_claim" "entertainment_content" {
  metadata {
    name      = "entertainment-content-pvc"
    namespace = kubernetes_namespace.entertainment.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "2Ti"
      }
    }
    storage_class_name = "jabberwock-nfs-csi"
    volume_mode        = "Filesystem"
  }
}