resource "adguard_config" "config" {
  filtering = {
    enabled         = true
    update_interval = 24
  }

  dns = {
    fallback_dns = [
      "tls://unfiltered.adguard-dns.com",
      "tls://dns.google",
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1"
    ]

    local_ptr_upstreams = [
      "10.0.0.1",
      "[/0.10.in-addr.arpa/]10.0.0.1",
    ]

    rate_limit = 0

    upstream_dns = [
      # Public DNS
      "https://dns.google/dns-query",
      "https://dns.cloudflare.com/dns-query",
      "https://dns.quad9.net/dns-query",
      "tls://dns.google",
      "tls://cloudflare-dns.com",
      # Internal reverse DNS lookup
      "[/0.10.in-addr.arpa/]10.0.0.1",
      "[/ip6.arpa/]10.0.0.1",
      "https://dns10.quad9.net/dns-query",
    ]

    bootstrap_dns = [
      "9.9.9.10",
      "149.112.112.10",
      "2620:fe::10",
      "2620:fe::fe:10"
    ]

    upstream_mode             = "parallel"
    use_private_ptr_resolvers = true

    cache_size = 4194304
  }

  stats = {
    enabled  = true
    interval = 720
  }
}