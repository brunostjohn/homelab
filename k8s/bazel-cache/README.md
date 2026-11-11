# Bazel cache

A Buildbarn remote cache (bb-storage) and executor (bb-scheduler) for the Macs' Bazel builds. The frontend checks
tokens, hides action results whose outputs were evicted, and forwards Execute to the scheduler. One storage shard
keeps the CAS and action cache in preallocated files on a 1 TiB `floof-iscsi-csi` volume.

Workers connect to the scheduler's node port, `10.0.2.22:30983`, with a token whose audience is `bazel-worker`
(`make-cache-token.sh <key dir> <name> bazel-worker`). That token lets a worker hand results straight back to
clients, so cache tokens can't register a worker. The Mac workers are set up by the repo's `tools/remote`. With no
worker of a platform left, Execute fails after two minutes and Bazel builds those actions on the asking Mac.

The Macs reach it at `grpc://10.0.2.22:30980`: the frontend's fixed node port, through the API server's VIP. Its
LoadBalancer address, `10.0.4.4:8980`, is not reachable from the client VLANs (10.0.5.10 wasn't either), while
older LoadBalancer addresses are. kube-vip logs adding the VIP on lan0 and the BGP host; the cause is not known yet.

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
