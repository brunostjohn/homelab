resource "adguard_rewrite" "k3s_ingress" {
  for_each = toset(["k3s.local", "argocd.local", "longhorn.local", "minio.local", "authentik.local", "traefik.local", "octoprint.local", "spoolman.local", "klipper.local", "fluidd.klipper.local"])

  domain = each.key
  answer = var.cluster_ipaddr
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
