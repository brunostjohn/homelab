resource "cloudflare_zone" "global_fqdn" {
  zone       = var.global_fqdn
  account_id = var.account_id
}

resource "cloudflare_record" "verification" {
  zone_id = cloudflare_zone.global_fqdn.id
  name    = "@"
  type    = "TXT"
  content = "oneuptime-verification-XqlwNkcvQSNlbFRmGepR"
  ttl     = 120
}