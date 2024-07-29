resource "unifi_wlan" "home" {
  name            = "Zefirs Terrace"
  passphrase      = var.wlan_home_password
  security        = "wpapsk"
  wpa3_support    = true
  wpa3_transition = true
  pmf_mode        = "optional"

  network_id    = unifi_network.default.id
  user_group_id = unifi_user_group.trusted_fast.id
  ap_group_ids = [
    data.unifi_ap_group.default.id
  ]
}