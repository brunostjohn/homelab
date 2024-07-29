resource "unifi_port_profile" "vlan_wan1_ports" {
  name = "VLAN WAN1 Ports"

  native_networkconf_id = unifi_network.wan1.id
  poe_mode              = "auto"
  dot1x_ctrl            = "auto"
}

resource "unifi_port_profile" "vlan_wan2_ports" {
  name = "VLAN WAN2 Ports"

  native_networkconf_id = unifi_network.wan2.id
  poe_mode              = "auto"
  dot1x_ctrl            = "auto"
}