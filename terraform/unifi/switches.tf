resource "unifi_device" "aggregation" {
  mac  = "f4:e2:c6:5c:b9:41"
  name = "Aggregation"

  port_override {
    aggregate_num_ports = 2
    name                = "Office Link 1"
    number              = 6
    op_mode             = "aggregate"
  }

  port_override {
    name    = "Office Link 2"
    number  = 7
    op_mode = "switch"
  }
}

resource "unifi_device" "switch_24_pro_max" {
  mac  = "9c:05:d6:69:54:81"
  name = "Office Switch"

  port_override {
    name                = "Aggregation Link 1"
    number              = 25
    aggregate_num_ports = 2
    op_mode             = "aggregate"
  }

  port_override {
    name            = "WAN2 Link"
    number          = 23
    op_mode         = "switch"
    port_profile_id = unifi_port_profile.vlan_wan2_ports.id
  }
}

resource "unifi_device" "switch_enterprise_8" {
  mac  = "78:45:58:dc:00:9a"
  name = "Living Room Switch"

  port_override {
    name            = "WAN1 Link"
    number          = 1
    op_mode         = "switch"
    port_profile_id = unifi_port_profile.vlan_wan1_ports.id
  }
}

resource "unifi_device" "switch_flex_mini" {
  mac  = "d8:b3:70:dc:fa:19"
  name = "TV Switch"
}