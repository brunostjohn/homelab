# Bazel cache

A Buildbarn remote cache (bb-storage) for the Macs' Bazel builds, at `grpc://10.0.5.10:8980` on the LAN. The
frontend checks tokens and hides action results whose outputs were evicted. One storage shard keeps the CAS and
action cache in preallocated files on a 1 TiB `floof-iscsi-csi` volume.

## Before the first sync

Run `make-cache-token.sh <key dir> <mac>` on a Mac. It mints an RS256 key the first time and a token on every run,
one per Mac. Paste the printed `n` over the placeholder in `config.yml`; it is the public half of the key.

## Notes

- Every size in `storage.jsonnet` is fixed when its file is first created. Changing one discards that store and the
  cache starts empty.
- bb_storage parses its config strictly against the protos of its own image. Buildbarn has no releases (the tag is a
  build date and commit), so a newer image can reject this config. Keep Renovate off these images and bump the image
  together with the config from `buildbarn/bb-deployments` at the same tag.
- Eviction drops the oldest block, about 1/38 of each store, at a time. Reading an object from the 8 oldest blocks
  copies it forward, so eviction is roughly LRU.
