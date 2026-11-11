# Stock MinIO Console

Builds the unmodified v1.7.6 Go module, including its upstream embedded web assets.
The immutable module is available through the Go module proxy even though the old
GitHub tag no longer resolves. Its source commit is
`f4a08fc0af8f776aa667677fb943aad137808f7c`.

This is the last full console used by the April 2025 server, with standalone OIDC
support. Newer upstream consoles removed that feature. This older release is not
a maintained security branch. Building it does not deploy it or change MinIO.
Validate it against the new server before deciding whether to retain it as the
household's administrative UI.

The standalone settings are `CONSOLE_MINIO_SERVER`, `CONSOLE_PBKDF_PASSPHRASE`,
`CONSOLE_PBKDF_SALT`, `CONSOLE_IDP_URL`, `CONSOLE_IDP_CLIENT_ID`,
`CONSOLE_IDP_SECRET`, `CONSOLE_IDP_CALLBACK` and comma-separated `CONSOLE_IDP_SCOPES`.
It needs no PVC. Do not put credentials in the image or build arguments.
