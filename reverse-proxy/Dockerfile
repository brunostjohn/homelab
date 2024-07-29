FROM caddy:builder AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare --with github.com/greenpau/caddy-git --with github.com/hslatman/caddy-crowdsec-bouncer --with github.com/WeidiDeng/caddy-cloudflare-ip

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy