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
  subnet           = "10.1.0.0/16"
  dhcp_start       = "10.1.0.1"
  dhcp_stop        = "10.0.255.254"
  dhcp_enabled     = true
  domain_name      = "localdomain"
  dhcp_v6_start    = "::2"
  dhcp_v6_stop     = "::7d1"
  ipv6_pd_start    = "::2"
  ipv6_pd_stop     = "::7d1"
  ipv6_ra_priority = "high"
}