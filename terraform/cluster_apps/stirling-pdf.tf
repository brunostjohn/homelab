resource "kubernetes_config_map" "stirling_pdf" {
  metadata {
    name      = "stirling-pdf-config"
    namespace = kubernetes_namespace.productivity.metadata[0].name
  }

  data = {
    "SECURITY_OAUTH2_ISSUER"       = "https://auth.${var.global_fqdn}/application/o/stirling-pdf/"
    "SECURITY_OAUTH2_CLIENTID"     = var.stirling_pdf_oidc_client_id
    "SECURITY_OAUTH2_CLIENTSECRET" = var.stirling_pdf_oidc_client_secret
  }
}

resource "argocd_application" "stirling_pdf" {
  depends_on = [kubernetes_config_map.stirling_pdf]

  metadata {
    name      = "stirling-pdf"
    namespace = "argocd"
  }

  spec {
    source {
      repo_url = var.homelab_repo
      path     = "k8s/stirling-pdf"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.productivity.metadata[0].name
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

module "stirling_pdf_ingress" {
  depends_on = [argocd_application.stirling_pdf]
  source     = "../ingress"

  service   = "stirling-pdf"
  port      = 8080
  hosts     = ["pdftools.${var.global_fqdn}"]
  namespace = kubernetes_namespace.productivity.metadata[0].name
}