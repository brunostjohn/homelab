resource "kubernetes_manifest" "default_tls_store" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "TLSStore"
    metadata = {
      name      = "default"
      namespace = "kube-system"
    }

    spec = {
      defaultCertificate = {
        secretName = kubernetes_manifest.root_cert_prod.manifest.spec.secretName
      }
    }
  }
}