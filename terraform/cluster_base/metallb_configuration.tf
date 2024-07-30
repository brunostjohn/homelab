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
        "10.0.2.0-10.0.2.255"
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