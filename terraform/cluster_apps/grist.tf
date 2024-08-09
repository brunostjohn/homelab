resource "kubernetes_namespace" "grist" {
  metadata {
    name = "grist"
  }
}

resource "kubernetes_secret" "grist" {
  metadata {
    name      = "grist-secrets"
    namespace = kubernetes_namespace.grist.metadata[0].name
  }

  data = {
    "GRIST_SESSION_SECRET" = var.grist_session_secret
    "GRIST_OIDC_IDP_ISSUER" = var.grist_oidc_idp_issuer
    "GRIST_OIDC_CLIENT_ID" = var.grist_oidc_client_id
    "GRIST_OIDC_CLIENT_SECRET" = var.grist_oidc_client_secret
  }
}

resource "argocd_application" "grist" {
  depends_on = [kubernetes_namespace.grist, kubernetes_secret.grist]

  metadata {
    name      = "grist"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/grist"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.grist.metadata[0].name
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