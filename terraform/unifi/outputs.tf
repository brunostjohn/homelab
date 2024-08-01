output "meowbox_ipaddr" {
  description = "meowbox' ip address"

  value = unifi_user.meowbox.fixed_ip
}

output "node1_pi_ipaddr" {
  description = "node1 pi's ip address"

  value = unifi_user.node1_pi.fixed_ip
}

output "node2_pi_ipaddr" {
  description = "node2 pi's ip address"

  value = unifi_user.node2_pi.fixed_ip
}

output "node3_pi_ipaddr" {
  description = "node3 pi's ip address"

  value = unifi_user.node3_pi.fixed_ip
}