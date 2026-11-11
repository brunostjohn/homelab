#!/bin/sh
# Mints the cache's RS256 signing key (once) and a bearer token for one Mac. Prints the public key's modulus for
# frontend.jsonnet and the remote.bazelrc line that carries the token. Only macOS's openssl, xxd and base64 are used.
#
#   make-cache-token.sh <private key directory> <mac name> [audience]
#
# The audience is bazel-cache (the frontend: cache and Execute) or bazel-worker (the scheduler's worker port).
#
# The private key only mints tokens; the cluster never sees it. A token has no expiry: revoke every token by minting
# a new key and replacing "n" in frontend.jsonnet.
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
header=$(printf '{"alg":"RS256","typ":"JWT","kid":"bazel-cache-1"}' | b64url)
payload=$(printf '{"aud":"%s","sub":"%s","iat":%s}' "$aud" "$mac" "$(date +%s)" | b64url)
signature=$(printf '%s.%s' "$header" "$payload" | openssl dgst -sha256 -sign "$key" -binary | b64url)

printf 'frontend.jsonnet "n":\n%s\n\n' "$modulus"
printf 'remote.bazelrc (keep private):\nbuild:remote "--remote_header=Authorization=Bearer %s.%s.%s"\n' \
  "$header" "$payload" "$signature"
