resource "unifi_user_group" "trusted_fast" {
  name              = "Trusted Fast"
  qos_rate_max_down = -1
  qos_rate_max_up   = -1
}

resource "unifi_user" "meowbox" {
  mac             = "98:b7:85:1f:a2:a7"
  name            = "Meowbox"
  dev_id_override = 1908
  blocked         = false

  fixed_ip   = "192.168.1.102"
  network_id = unifi_network.default.id
  site       = unifi_site.home.name
}