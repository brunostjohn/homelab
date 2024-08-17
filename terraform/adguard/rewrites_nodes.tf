resource "adguard_rewrite" "k3s_ingress" {
  for_each = toset([
    "requestrr.local",
    "qbittorrent.local",
    "argocd.local",
    "longhorn.local",
    "minio.local",
    "authentik.local",
    "traefik.local",
    "spoolman.local",
    var.global_fqdn,
    "*.${var.global_fqdn}",
    "*.static.${var.global_fqdn}",
    "radarr.local",
    "sonarr.local",
    "readarr.local",
    "lidarr.local",
    "prowlarr.local",
    "qbittorrent.local",
    "alertmanager.local"
  ])

  domain = each.key
  answer = var.cluster_ipaddr
}

resource "adguard_rewrite" "control_plane" {
  for_each = toset(["control-plane.k3s.local"])

  domain = each.key
  answer = var.control_plane_ipaddr
}

resource "adguard_rewrite" "meowbox" {
  for_each = toset(["meowbox.local"])

  domain = each.key
  answer = var.meowbox_ipaddr
}

resource "adguard_rewrite" "node1_pi" {
  for_each = toset(["node1.zefirscloud.local"])

  domain = each.key
  answer = var.node1_pi_ipaddr
}

resource "adguard_rewrite" "node2_pi" {
  for_each = toset(["node2.zefirscloud.local"])

  domain = each.key
  answer = var.node2_pi_ipaddr
}

resource "adguard_rewrite" "node3_pi" {
  for_each = toset(["node3.zefirscloud.local"])

  domain = each.key
  answer = var.node3_pi_ipaddr
}
