resource "kubernetes_manifest" "static_subdomain_cert_prod" {
  depends_on = [kubernetes_manifest.letsencrypt_prod_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "static-subdomain-cert"
      namespace = "cert-manager"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "static-wildcard-prod"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_prod_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = "*.static.${var.global_fqdn}"
      dnsNames = [
        "*.static.${var.global_fqdn}"
      ]
    }
  }
}

resource "kubernetes_manifest" "static_subdomain_cert_staging" {
  depends_on = [kubernetes_manifest.letsencrypt_staging_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "static-subdomain-cert-staging"
      namespace = "cert-manager"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "static-wildcard-staging"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_staging_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = "*.static.${var.global_fqdn}"
      dnsNames = [
        "*.static.${var.global_fqdn}"
      ]
    }
  }
}

resource "kubernetes_manifest" "subdomain_cert_prod" {
  depends_on = [kubernetes_manifest.letsencrypt_prod_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "subdomain-cert"
      namespace = "cert-manager"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "wildcard-prod"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_prod_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = "*.${var.global_fqdn}"
      dnsNames = [
        "*.${var.global_fqdn}"
      ]
    }
  }
}

resource "kubernetes_manifest" "subdomain_cert_staging" {
  depends_on = [kubernetes_manifest.letsencrypt_staging_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "subdomain-cert-staging"
      namespace = "cert-manager"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "wildcard-staging"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_staging_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = "*.${var.global_fqdn}"
      dnsNames = [
        "*.${var.global_fqdn}"
      ]
    }
  }
}

resource "kubernetes_manifest" "root_cert_prod" {
  depends_on = [kubernetes_manifest.letsencrypt_prod_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "root-cert"
      namespace = "cert-manager"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "root-prod"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_prod_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = var.global_fqdn
      dnsNames = [
        var.global_fqdn
      ]
    }
  }
}

resource "kubernetes_manifest" "root_cert_staging" {
  depends_on = [kubernetes_manifest.letsencrypt_staging_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "root-cert-staging"
      namespace = "cert-manager"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "root-staging"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_staging_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = var.global_fqdn
      dnsNames = [
        var.global_fqdn
      ]
    }
  }
}