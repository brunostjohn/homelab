resource "adguard_rewrite" "meowbox" {
  domain = "meowbox.local"
  answer = var.meowbox_ipaddr
}