resource "kubernetes_namespace" "ns" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}