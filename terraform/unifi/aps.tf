resource "unifi_device" "ap_u7_pro_living_room" {
  mac  = "9c:05:d6:49:ab:49"
  name = "Living Room AP"
}

resource "unifi_device" "ap_u7_pro_hall" {
  mac  = "9c:05:d6:a6:3c:88"
  name = "Hall AP"
}

data "unifi_ap_group" "default" {
  name = "Home APs"
}