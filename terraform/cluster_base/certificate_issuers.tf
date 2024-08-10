resource "kubernetes_manifest" "selfsigned_issuer" {
  depends_on = [module.cert_manager]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "selfsigned"
    }

    spec = {
      selfSigned = {}
    }
  }
}

resource "kubernetes_secret" "cloudflare_keys" {
  depends_on = [module.cert_manager]

  metadata {
    name      = "cloudflare-keys"
    namespace = "cert-manager"
  }

  type = "Opaque"

  data = {
    api-token = var.letsencrypt_cloudflare_api_token
  }
}

resource "kubernetes_manifest" "letsencrypt_staging_issuer" {
  depends_on = [kubernetes_secret.cloudflare_keys]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }

    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        email  = var.letsencrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-staging"
        }

        solvers = [
          {
            dns01 = {
              cloudflare = {
                email = var.letsencrypt_email
                apiTokenSecretRef = {
                  name = kubernetes_secret.cloudflare_keys.metadata[0].name
                  key  = "api-token"
                }
              }
            }
          }
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "letsencrypt_prod_issuer" {
  depends_on = [kubernetes_secret.cloudflare_keys]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }

    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.letsencrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }

        solvers = [
          {
            dns01 = {
              cloudflare = {
                email = var.letsencrypt_email
                apiTokenSecretRef = {
                  name = kubernetes_secret.cloudflare_keys.metadata[0].name
                  key  = "api-token"
                }
              }
            }
          }
        ]
      }
    }
  }

}