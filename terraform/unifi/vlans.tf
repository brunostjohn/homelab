resource "unifi_network" "wan1" {
  name    = "VLAN-WAN1"
  purpose = "vlan-only"
  vlan_id = 6
}

resource "unifi_network" "wan2" {
  name    = "VLAN-WAN2"
  purpose = "vlan-only"
  vlan_id = 3
}

resource "unifi_network" "default" {
  name             = "Default"
  purpose          = "corporate"
  multicast_dns    = true
  subnet           = "192.168.1.0/24"
  dhcp_start       = "192.168.1.6"
  dhcp_stop        = "192.168.1.254"
  dhcp_enabled     = true
  domain_name      = "localdomain"
  dhcp_v6_start    = "::2"
  dhcp_v6_stop     = "::7d1"
  ipv6_pd_start    = "::2"
  ipv6_pd_stop     = "::7d1"
  ipv6_ra_priority = "high"
}