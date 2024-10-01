resource "kubernetes_manifest" "root_cert_prod" {
  depends_on = [kubernetes_manifest.letsencrypt_prod_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "root-cert"
      namespace = "kube-system"

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
        var.global_fqdn,
        "*.${var.global_fqdn}",
        "*.static.${var.global_fqdn}",
        "*.envs.${var.global_fqdn}"
      ]
    }
  }
}

resource "kubernetes_manifest" "second_cert_prod" {
  depends_on = [kubernetes_manifest.letsencrypt_prod_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "second-cert"
      namespace = "kube-system"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "second-prod"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_prod_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = var.second_fqdn
      dnsNames = [
        var.second_fqdn,
        "*.${var.second_fqdn}",
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
      namespace = "kube-system"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"            = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled"       = "true"
        "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces" = "productivity"
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
        var.global_fqdn,
        "*.${var.global_fqdn}",
        "*.static.${var.global_fqdn}",
        "*.envs.${var.global_fqdn}"
      ]
    }
  }
}

resource "kubernetes_manifest" "second_cert_staging" {
  depends_on = [kubernetes_manifest.letsencrypt_staging_issuer]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Certificate"
    metadata = {
      name      = "second-cert-staging"
      namespace = "kube-system"

      annotations = {
        "reflector.v1.k8s.emberstack.com/reflection-allowed"      = "true"
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled" = "true"
      }
    }

    spec = {
      secretName = "second-staging"
      issuerRef = {
        name = kubernetes_manifest.letsencrypt_staging_issuer.manifest.metadata.name
        kind = "ClusterIssuer"
      }
      commonName = var.second_fqdn
      dnsNames = [
        var.second_fqdn,
        "*.${var.second_fqdn}",
      ]
    }
  }
}