resource "kubernetes_manifest" "metallb_addresses" {
  depends_on = [argocd_application.metallb]

  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "IPAddressPool"
    "metadata" = {
      "name"      = "pool"
      "namespace" = "metallb"
    }
    "spec" = {
      "addresses" = [
        "192.168.1.2-192.168.1.4"
      ]
    }
  }
}

resource "kubernetes_manifest" "metallb_l2_advertisement" {
  depends_on = [kubernetes_manifest.metallb_addresses]

  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "L2Advertisement"
    "metadata" = {
      "name"      = "l2"
      "namespace" = "metallb"
    }
    "spec" = {
      "ipAddressPools" = ["pool"]
    }
  }
}