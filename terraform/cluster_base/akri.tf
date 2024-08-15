resource "kubernetes_namespace" "akri" {
  metadata {
    name = "akri"
  }
}

resource "helm_release" "akri" {
  depends_on = [kubernetes_namespace.akri, helm_release.argocd, kubernetes_ingress_v1.argocd_ingress]

  name      = "akri"
  namespace = kubernetes_namespace.akri.metadata[0].name

  wait          = true
  wait_for_jobs = true

  repository = "https://project-akri.github.io/akri/"
  chart      = "akri"
  version    = "0.12.20"

  values = [file("${path.module}/values/akri.yml")]
}