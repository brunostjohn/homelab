resource "kubernetes_namespace" "opengist" {
  metadata {
    name = "opengist"
  }
}

resource "kubernetes_secret" "opengist" {
  metadata {
    name      = "opengist-secrets"
    namespace = kubernetes_namespace.opengist.metadata[0].name
  }

  data = {
    "OG_OIDC_SECRET" = var.opengist_oidc_client_secret
  }
}

resource "kubernetes_config_map" "opengist" {
  metadata {
    name      = "opengist-config"
    namespace = kubernetes_namespace.opengist.metadata[0].name
  }

  data = {
    "OG_EXTERNAL_URL"       = "https://gist.${var.global_fqdn}"
    "OG_OIDC_CLIENT_KEY"    = var.opengist_oidc_client_id
    "OG_OIDC_DISCOVERY_URL" = "https://auth.${var.global_fqdn}/application/o/opengist/.well-known/openid-configuration"
  }
}

resource "argocd_application" "opengist" {
  depends_on = [kubernetes_config_map.opengist, kubernetes_secret.opengist]

  metadata {
    name      = "opengist"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/programming/opengist"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.opengist.metadata[0].name
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
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

module "opengist_ingress" {
  depends_on = [argocd_application.opengist]
  source     = "../ingress"

  service   = "opengist"
  hosts     = ["gist.${var.global_fqdn}"]
  namespace = kubernetes_namespace.opengist.metadata[0].name
  port      = 6157
}