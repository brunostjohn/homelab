resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb"
  }
}

resource "argocd_application" "metallb" {
  depends_on = [kubernetes_namespace.metallb]

  metadata {
    name      = "metallb"
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "metallb"
    }

    source {
      repo_url        = "https://metallb.github.io/metallb"
      chart           = "metallb"
      target_revision = "v0.14"
    }

    sync_policy {
      automated {
        self_heal   = true
        prune       = true
        allow_empty = true
      }

      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}

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