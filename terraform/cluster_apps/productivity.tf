resource "kubernetes_namespace" "productivity" {
  metadata {
    name = "productivity"
  }
}