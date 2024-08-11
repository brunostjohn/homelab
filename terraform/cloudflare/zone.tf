resource "cloudflare_zone" "global_fqdn" {
  zone       = var.global_fqdn
  account_id = var.account_id
}