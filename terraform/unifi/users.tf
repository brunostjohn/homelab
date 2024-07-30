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

  fixed_ip   = "10.0.0.2"
  network_id = unifi_network.default.id
}

resource "unifi_user" "node2_pi" {
  mac             = "2c:cf:67:14:9b:3c"
  name            = "Failover Pi"
  dev_id_override = 2813
  blocked         = false

  fixed_ip   = "10.0.0.3"
  network_id = unifi_network.default.id
}

resource "unifi_user" "node3_pi" {
  mac             = "b8:27:eb:c3:f6:83"
  name            = "3D Print Pi"
  dev_id_override = 2813

  fixed_ip   = "10.0.0.4"
  network_id = unifi_network.default.id
}