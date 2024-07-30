output "meowbox_ipaddr" {
  description = "meowbox' ip address"

  value = unifi_user.meowbox.fixed_ip
}