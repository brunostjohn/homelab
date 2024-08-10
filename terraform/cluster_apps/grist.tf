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
    "GRIST_SESSION_SECRET"     = var.grist_session_secret
    "GRIST_OIDC_IDP_ISSUER"    = var.grist_oidc_idp_issuer
    "GRIST_OIDC_CLIENT_ID"     = var.grist_oidc_client_id
    "GRIST_OIDC_CLIENT_SECRET" = var.grist_oidc_client_secret
  }
}

resource "kubernetes_config_map" "grist_fqdn" {
  metadata {
    name      = "grist-fqdn"
    namespace = kubernetes_namespace.grist.metadata[0].name
  }

  data = {
    "GRIST_FQDN" = "https://grist.${var.global_fqdn}"
  }
}

resource "argocd_application" "grist" {
  depends_on = [kubernetes_namespace.grist, kubernetes_secret.grist, kubernetes_config_map.grist_fqdn]

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

resource "kubernetes_ingress_v1" "grist_ingress" {
  depends_on = [ argocd_application.grist ]

  metadata {
    name      = "grist"
    namespace = kubernetes_namespace.grist.metadata[0].name
  }

  spec {
    ingress_class_name = "traefik"

    rule {
      host = "grist.${var.global_fqdn}"

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = "grist-service"

              port {
                number = 8484
              }
            }
          }
        }
      }
    }
  }
}