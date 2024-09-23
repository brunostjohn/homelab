resource "kubernetes_namespace" "immich" {
  metadata {
    name = "immich"
  }
}

resource "kubernetes_persistent_volume_claim" "immich_library" {
    metadata {
    name      = "immich-library"
    namespace = kubernetes_namespace.immich.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "floof-nfs-csi"
    resources {
      requests = {
        storage = "400Gi"
      }
    }
  }
}

module "immich_helm" {
  depends_on = [kubernetes_persistent_volume_claim.immich_library]

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
  values = templatefile("${path.module}/templates/immich.yml.tpl", {
    db_password = var.immich_db_password
  })
}