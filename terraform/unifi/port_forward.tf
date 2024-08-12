resource "unifi_port_forward" "meowbox_http" {
  port_forward_interface = "wan"
  protocol               = "tcp"
  fwd_port               = 80
  dst_port               = 80
  fwd_ip                 = unifi_user.meowbox.fixed_ip
  log                    = true
  name                   = "HTTP Port Forward"
}

resource "unifi_port_forward" "meowbox_https" {
  port_forward_interface = "wan"
  protocol               = "tcp"
  fwd_port               = 443
  dst_port               = 443
  fwd_ip                 = unifi_user.meowbox.fixed_ip
  log                    = true
  name                   = "HTTPS Port Forward"
}

resource "unifi_port_forward" "meowbox_mc" {
  port_forward_interface = "wan"
  protocol               = "tcp"
  fwd_port               = 25565
  dst_port               = 25565
  fwd_ip                 = unifi_user.meowbox.fixed_ip
  log                    = true
  name                   = "Minecraft Port Forward"
}

resource "unifi_port_forward" "cluster_qbittorrent" {
  port_forward_interface = "wan"
  protocol               = "tcp_udp"
  fwd_port               = 6881
  dst_port               = 6881
  fwd_ip                 = "10.0.2.9"
  log                    = true
  name                   = "qBittorrent Port Forward"
}