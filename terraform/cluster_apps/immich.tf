resource "kubernetes_namespace" "immich" {
  metadata {
    name = "immich"
  }
}

resource "kubernetes_persistent_volume_claim" "immich_library_pvc" {
  metadata {
    name      = "immich-library-pvc"
    namespace = kubernetes_namespace.immich.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "nfs-jabberwock-subpath"
    resources {
      requests = {
        storage = "100Gi"
      }
    }
  }
}

module "immich_helm" {
  depends_on = [kubernetes_persistent_volume_claim.immich_library_pvc]

  source           = "../helm_deployment"
  namespace        = kubernetes_namespace.immich.metadata[0].name
  name             = "immich"
  create_namespace = false

  create_ingress = true
  service_name   = "immich-server"
  service_port   = 3001
  hosts          = ["window.${var.global_fqdn}"]

  chart           = "immich"
  repo_url        = "https://immich-app.github.io/immich-charts"
  target_revision = "0.7.1"
  values          = file("${path.module}/values/immich.yml")
}