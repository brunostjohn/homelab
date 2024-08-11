[poller]
    debug = false
    quiet = false
    plugins = []
[prometheus]
    disable = false
    http_listen = "0.0.0.0:9130"
    report_errors = false
[unifi]
    dynamic = false
[[unifi.controller]]
    url         = "https://10.0.0.1"
    user        = "${username}"
    pass        = "${password}"
    sites       = ["all"]
    save_ids    = true
    save_dpi    = true
    save_sites  = true
    hash_pii    = false
    verify_ssl  = false