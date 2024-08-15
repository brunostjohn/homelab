resource "kubernetes_namespace" "cloudflare_ddns" {
  metadata {
    name = "cloudflare-ddns"
  }
}

resource "kubernetes_config_map" "cloudflare_ddns" {
  metadata {
    name      = "cloudflare-ddns-config"
    namespace = kubernetes_namespace.cloudflare_ddns.metadata[0].name
  }

  data = {
    domains = "${var.global_fqdn},*.${var.global_fqdn},*.static.${var.global_fqdn},corner.${var.global_fqdn},cubes.${var.global_fqdn},carrier.${var.global_fqdn}"
    proxied = "!(is(corner.${var.global_fqdn}) || is(cubes.${var.global_fqdn}) || is(carrier.${var.global_fqdn}))"
  }
}

resource "kubernetes_secret" "cloudflare_ddns" {
  metadata {
    name      = "cloudflare-ddns-secrets"
    namespace = kubernetes_namespace.cloudflare_ddns.metadata[0].name
  }

  data = {
    "api-token" = var.cloudflare_ddns_api_token
  }
}

resource "argocd_application" "cloudflare_ddns" {
  depends_on = [kubernetes_secret.cloudflare_ddns, kubernetes_config_map.cloudflare_ddns]

  metadata {
    name      = "cloudflare-ddns"
    namespace = "argocd"
  }

  wait = true

  spec {
    source {
      repo_url        = argocd_repository.homelab_github.repo
      path            = "k8s/cloudflare-ddns"
      target_revision = "main"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.cloudflare_ddns.metadata[0].name
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