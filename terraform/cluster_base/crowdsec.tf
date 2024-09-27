module "crowdsec" {
  depends_on = [argocd_application.longhorn, module.reflector]
  source     = "../helm_deployment"

  namespace        = "crowdsec"
  create_namespace = true

  name            = "crowdsec"
  chart           = "crowdsec"
  repo_url        = "https://crowdsecurity.github.io/helm-charts"
  target_revision = "0.11.0"

  project = argocd_project.security.metadata[0].name

  values = templatefile("${path.module}/values/crowdsec.yml.tpl", {
    enroll_key          = var.crowdsec_enroll_key
    bouncer_key_traefik = var.crowdsec_bouncer_key_traefik
    db_password = var.crowdsec_db_password
  })

  create_ingress = false
}

resource "kubernetes_manifest" "crowdsec_traefik_middleware" {
  depends_on = [module.crowdsec]

  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "bouncer"
      namespace = "kube-system"
    }
    spec = {
      plugin = {
        bouncer = {
          enabled                                  = true
          crowdsecMode                             = "stream"
          crowdsecLapiScheme                       = "https"
          crowdsecLapiHost                         = "crowdsec-service.crowdsec.svc.cluster.local:8080"
          crowdsecLapiKey                          = var.crowdsec_bouncer_key_traefik
          crowdsecLapiTLSCertificateAuthorityFile  = "/etc/traefik/crowdsec-certs/ca.crt"
          crowdsecLapiTLSCertificateBouncerFile    = "/etc/traefik/crowdsec-certs/tls.crt"
          crowdsecLapiTLSCertificateBouncerKeyFile = "/etc/traefik/crowdsec-certs/tls.key"
        }
      }
    }
  }
}