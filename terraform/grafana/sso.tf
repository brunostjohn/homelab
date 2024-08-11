resource "grafana_sso_settings" "sso" {
  provider_name = "generic_oauth"

  oauth2_settings {
    name    = "Zefir's Cloud"
    enabled = true

    client_id     = var.client_id
    client_secret = var.client_secret

    allow_sign_up = true
    auto_login    = true
    scopes        = "openid profile email"

    auth_url  = "https://auth.${var.global_fqdn}/application/o/authorize/"
    api_url   = "https://auth.${var.global_fqdn}/application/o/userinfo/"
    token_url = "https://auth.${var.global_fqdn}/application/o/token/"

    use_pkce          = true
    use_refresh_token = true

    skip_org_role_sync = true
  }
}