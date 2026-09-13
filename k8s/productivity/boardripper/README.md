# BoardRipper

Public URL: https://boards.zefirsroyal.cloud

MCP URL: https://boards.zefirsroyal.cloud/api/mcp

Argo CD discovers this application from `apps/clusterApps/templates/boardripper.yaml`.
Deploy changes through Git and Argo CD.

## Storage

The existing NAS export `10.0.3.1:/mnt/jabberwock/shares/global` is mounted
read-only, with only its `Repair Schematics` subdirectory visible to the app.
Do not change the NAS files' ownership, mode, or ACLs. Any access adjustment
must be confined to the NFS share settings.

The separate `boardripper-data` local-path PVC stores SQLite databases,
indexes, settings, persistent MCP pairing credentials, and uploads.
`/library/incoming` uses the PVC, so uploads never write to the NAS collection.
The PVC is excluded from automatic pruning. Local-path storage is tied to
the selected node; it is not replicated and its requested size is not an
enforced quota.

## Authentication

Create an Authentik application with slug `boardripper` and a proxy provider
in **Forward auth (single application)** mode, external host
`https://boards.zefirsroyal.cloud`. Attach it to the existing **Proxy Outpost**
and bind the intended user's access policy. No unauthenticated-path regex is
needed in Authentik: exact ingress paths handle MCP separately.

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
