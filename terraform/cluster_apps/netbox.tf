resource "kubernetes_namespace" "netbox" {
  metadata {
    name = "netbox"
  }
}

resource "kubernetes_config_map" "netbox_sso_pipeline_roles" {
  metadata {
    name      = "sso-pipeline-roles"
    namespace = kubernetes_namespace.netbox.metadata[0].name
  }

  data = {
    "sso_pipeline_roles.py" = templatefile("${path.module}/templates/sso_pipeline_roles.py.tpl", {
      oidc_client_id = var.netbox_oidc_client_id
    })
  }
}

resource "kubernetes_secret" "netbox_oidc_client" {
  metadata {
    name      = "oidc-client"
    namespace = kubernetes_namespace.netbox.metadata[0].name
  }

  data = {
    "oidc.yaml" = templatefile("${path.module}/templates/netbox-oidc.yml.tpl", {
      client_id     = var.netbox_oidc_client_id
      client_secret = var.netbox_oidc_client_secret
      oidc_endpoint = "https://auth.${var.global_fqdn}/application/o/netbox/"
      logout_url    = "https://auth.${var.global_fqdn}/application/o/netbox/end-session/"
    })
  }
}

module "netbox_helm" {
  depends_on = [kubernetes_config_map.netbox_sso_pipeline_roles, kubernetes_secret.netbox_oidc_client]
  source     = "../helm_deployment"

  chart           = "netbox"
  target_revision = "5.0.0-beta.82"
  repo_url        = "https://charts.netbox.oss.netboxlabs.com/"
  values = templatefile("${path.module}/templates/netbox.yml.tpl", {
    superuser_name        = var.netbox_superuser_name
    superuser_email       = var.netbox_superuser_email
    superuser_password    = var.netbox_superuser_password
    aws_access_key_id     = var.netbox_aws_access_key_id
    aws_secret_access_key = var.netbox_aws_secret_access_key
    global_fqdn           = var.global_fqdn
  })

  name             = "netbox"
  namespace        = kubernetes_namespace.netbox.metadata[0].name
  create_namespace = false

  create_ingress = false
}