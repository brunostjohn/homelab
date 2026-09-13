# BoardRipper

Public URL: https://boards.zefirsroyal.cloud

MCP URL: https://boards.zefirsroyal.cloud/api/mcp

Argo CD discovers this application from `apps/clusterApps/templates/boardripper.yaml`.
Deploy changes through Git and Argo CD.

## Storage

The NAS export `10.0.3.1:/mnt/jabberwock/shares/global/Repair Schematics` is
mounted read-only and exposes only the repair collection to the app.
Do not change the NAS files' ownership, mode, or ACLs. Any access adjustment
must be confined to the NFS share settings.

The NFS share is restricted to `10.0.0.0/16` and maps clients to
the `root:shareusers` identity so existing root-owned folders are readable
without changing their permissions. The container still runs as UID/GID 65532.
Kubernetes mounts the repair folder directly; it does not use an NFS `subPath`
mount. The export permits the scheduled sync job to write; both BoardRipper
volume settings remain read-only.

The separate `boardripper-data` local-path PVC stores SQLite databases,
indexes, settings, persistent MCP pairing credentials, and uploads.
`/library/incoming` uses the PVC, so uploads never write to the NAS collection.
The PVC is excluded from automatic pruning. Local-path storage is tied to
the selected node; it is not replicated and its requested size is not an
enforced quota.

## Authentication

Authentik application `boardripper` uses `Provider for BoardRipper` (ID 426)
in **Forward auth (single application)** mode, external host
`https://boards.zefirsroyal.cloud`. It is assigned to the existing **Proxy Outpost**
with a user binding for `bruno` (Bruno St John). The outpost manages its own
`/outpost.goauthentik.io` ingress. Header authentication interception is disabled;
the unauthenticated-path list is empty. Exact ingress paths handle MCP separately.

The main ingress requires Authentik. In particular, `/api/mcp/token`, pairing,
settings, the browser bridge, and `/api/mcp/oauth/authorize` remain protected.
Only exact MCP transport, discovery, registration, JWKS, and OAuth token
exchange paths bypass the browser login. BoardRipper validates bearer tokens
on the MCP transport and authorization codes with PKCE during token exchange.
Never expose the whole `/api/mcp` prefix without Authentik.

In BoardRipper Settings > Integrations, enable MCP and select OAuth to support
clients that discover OAuth automatically. For clients configured with an
Authorization header, use **This browser's agent** pairing token to restrict
live tools to that browser. The shared token and OAuth grants are install-wide.
Upstream OAuth grants are held in memory and expire on restart; persistent
pairing tokens survive restarts on the PVC.

Enable automatic library scanning in Settings. All configuration persists
on the data PVC. Keep browser control tools disabled unless explicitly wanted.

## Incremental XZZ sync

`boardripper-xzz-sync` runs daily at 04:00 in `Europe/Dublin`, using the existing
`XZZ 2025` directory. Infisical supplies `USERNAME` and `PASSWORD` from
`/xzz_repo` in the cluster secrets project's `dev` environment. Only Secret
references belong in Git; never commit credentials or private library manifests.

The worker compares the remote manifest and hashes against a persistent trusted
baseline. It downloads missing files and repairs local hash mismatches, keeping
recovery copies of replaced bytes in `.xzz-sync-backups`. It never propagates
remote deletions. A changed hash for an already trusted remote path requires
review; a large catalog reduction or mass hash change freezes the run.

Repairs write through the original inode to preserve ownership, mode and ACLs.
Verified downloads, recovery journals and bounded verification checkpoints
support retries. Keep the state PVC and recovery copies: they hold the trust
baseline and rollback evidence, not another copy of the whole collection.

The daily run is limited to 5.5 hours, 50 GiB of file transfers, and 200,000
file operations/checks, with a 2 MiB/s transfer target. Unfinished work resumes
on the next run. The first audit reads existing local bytes to establish a
verification cache; later runs hash only changed local file fingerprints.
Each run fetches the remote manifest and hash index, not the whole corpus.
Files without published checksums are left for review. Existing byte-identical
files at verified alternative paths are reused without creating another copy.
A 5 GiB free-space reserve protects the destination from filling up.

The initial trust baseline and verified aliases are stored only on the state
PVC, outside Git. Do not regenerate that baseline from a changed remote source
to clear a freeze. Review receipts in `/state/receipts`, compare the pinned
hashes and retained backups, and approve any legitimate upstream changes
explicitly. The script exits nonzero for freezes, failed transfers, or changes
requiring review, so Kubernetes records a failed Job. It does not send alerts.

After downloads or repairs, the worker requests a BoardRipper library scan.
An unavailable/busy scanner is retried on the next applying run. Metadata-only
categorization uses the BoardRipper API and never renames NAS files.

Worker source: `scripts/boardripper-xzz-sync/xzz_sync.py`. Regenerate its
ConfigMap with `python3 scripts/boardripper-xzz-sync/build_configmap.py` after
editing, and run `python3 -m unittest discover -s scripts/boardripper-xzz-sync`.

## Updates and verification

The image is pinned to a release and digest. Update it through Git/Argo;
there is no Docker socket or writable root filesystem for in-app self-updates.

After deployment, verify:

- Argo reports Synced/Healthy and the pod is Ready.
- The library can list and open existing boardviews and schematics.
- Logged-out requests for `/`, `/api/config`, `/api/mcp/token`, pairing,
  and OAuth consent redirect to Authentik.
- A request to `/api/mcp` without a token returns 401, not a login redirect.
- OAuth discovery advertises HTTPS URLs at the public hostname.
- A valid token can initialize MCP, list tools, and read the library.
- A fresh Authentik login reaches the app and the browser bridge connects.
