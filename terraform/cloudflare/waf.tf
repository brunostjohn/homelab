# resource "cloudflare_ruleset" "known_bots_unknown_countries" {
#   zone_id = cloudflare_zone.global_fqdn.id

#   name = "Known Bots and Unknown Countries"
#   description = "Block known bots and requests from countries other than Ireland, the United Kingdom, and the United States"

#   phase = "http_request_firewall_custom"
#   kind  = "zone"

#   rules {
#     action = "block"
#     expression = "((not ip.geoip.country in {\"IE\" \"GB\" \"US\"}) or (cf.client.bot) or (cf.threat_score gt 49))"
#     description = "Block requests from countries other than Ireland, the United Kingdom, and the United States, known bots, and requests with a threat score greater than 49"
#     enabled = true
#   }
# }