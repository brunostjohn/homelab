#!/bin/sh
# Mints the cache's RS256 signing key (once) and a bearer token for one Mac. Prints the public key's modulus for
# frontend.jsonnet and the remote.bazelrc line that carries the token. Only macOS's openssl, xxd and base64 are used.
#
#   make-cache-token.sh <private key directory> <mac name> [audience]
#
# The audience is bazel-cache (the frontend: cache and Execute) or bazel-worker (the scheduler's worker port).
#
# The private key only mints tokens; the cluster never sees it. A token has no expiry: revoke every token by minting
# a new key and replacing the key in config.yml (frontend and scheduler); list both keys while tokens are swapped.
set -eu

dir=${1:?usage: make-cache-token.sh <private key directory> <mac name>}
mac=${2:?usage: make-cache-token.sh <private key directory> <mac name>}
aud=${3:-bazel-cache}
case $aud in bazel-cache | bazel-worker) ;; *) echo "audience: bazel-cache or bazel-worker" >&2; exit 2 ;; esac
umask 077
mkdir -p "$dir"
key="$dir/bazel-cache-signing.pem"
[ -f "$key" ] || openssl genrsa -out "$key" 3072 2>/dev/null

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

modulus=$(openssl rsa -in "$key" -noout -modulus | sed 's/^Modulus=//' | xxd -r -p | b64url)
# The key ID names the key, so the frontend can hold an old and a new key while the Macs' tokens are swapped.
kid=bazel-cache-$(printf '%s' "$modulus" | openssl dgst -sha256 | sed 's/^.* //' | cut -c1-8)
header=$(printf '{"alg":"RS256","typ":"JWT","kid":"%s"}' "$kid" | b64url)
payload=$(printf '{"aud":"%s","sub":"%s","iat":%s}' "$aud" "$mac" "$(date +%s)" | b64url)
signature=$(printf '%s.%s' "$header" "$payload" | openssl dgst -sha256 -sign "$key" -binary | b64url)

printf 'frontend.jsonnet "kid": "%s", "n":\n%s\n\n' "$kid" "$modulus"
printf 'remote.bazelrc (keep private):\nbuild:remote "--remote_header=Authorization=Bearer %s.%s.%s"\n' \
  "$header" "$payload" "$signature"
