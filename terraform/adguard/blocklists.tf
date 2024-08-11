resource "adguard_list_filter" "adguard_dns_filter" {
  name = "AdGuard DNS filter"
  url  = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
}

resource "adguard_list_filter" "adaway_default_blocklist" {
  name = "AdAway Default Blocklist"
  url  = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt"
}

resource "adguard_list_filter" "steven_black" {
  name = "Steven Black's List"
  url  = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
}

resource "adguard_list_filter" "dev_dan_ads_tracking" {
  name = "Developer Dan's Ads & Tracking"
  url  = "https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt"
}

resource "adguard_list_filter" "dev_dan_hate_junk" {
  name = "Developer Dan's Hate & Junk"
  url  = "https://www.github.developerdan.com/hosts/lists/hate-and-junk-extended.txt"
}

resource "adguard_list_filter" "adaway" {
  name = "AdAway"
  url  = "https://adaway.org/hosts.txt"
}

resource "adguard_list_filter" "firebog" {
  name = "FireBog"
  url  = "https://v.firebog.net/hosts/AdguardDNS.txt"
}

resource "adguard_list_filter" "firebog_admiral" {
  name = "FireBog Admiral"
  url  = "https://v.firebog.net/hosts/Admiral.txt"
}

resource "adguard_list_filter" "adservers" {
  name = "Adservers Blacklist"
  url  = "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
}

resource "adguard_list_filter" "firebog_easy" {
  name = "FireBog EasyList"
  url  = "https://v.firebog.net/hosts/Easylist.txt"
}

resource "adguard_list_filter" "yoyo" {
  name = "Yoyo"
  url  = "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
}

resource "adguard_list_filter" "unchecky" {
  name = "Unchecky"
  url  = "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
}