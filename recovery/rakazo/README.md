# Rakazo encryption-key recovery

The local, Git-ignored `encryption-key.rsa-oaep` is an encrypted copy of the existing Rakazo
`ENCRYPTION_KEY`, captured on 11 November 2026. It is not a new application key.
Encryption and decryption were verified against the live value without displaying
plaintext. The encrypted artifact stays on the operator laptop; it is not uploaded to
GitHub. No plaintext application key or private SSH key is in this repository.

Recipient: Bruno's existing 4096-bit RSA SSH identity (`~/.ssh/id_rsa`). Its public
fingerprint is `SHA256:FjqdCszvKL6trHOC6g1wpTLGvqcoFEMpBukKea/VpcM`.
Keep a recoverable copy of that private identity separately from the cluster.
The format is raw RSA-OAEP ciphertext, with SHA-256 for both OAEP and MGF1.

To recover, make a private temporary PEM copy of the matching SSH identity, then
decrypt to a private file. The conversion prompts for passphrases; use an empty
new passphrase for this disposable copy. It does not modify the original identity.

```sh
umask 077
recovery_tmp=$(mktemp -d)
trap 'rm -rf "$recovery_tmp"' EXIT
cp ~/.ssh/id_rsa "$recovery_tmp/identity"
ssh-keygen -p -m PEM -f "$recovery_tmp/identity"
openssl pkeyutl -decrypt \
  -inkey "$recovery_tmp/identity" \
  -in recovery/rakazo/encryption-key.rsa-oaep \
  -pkeyopt rsa_padding_mode:oaep \
  -pkeyopt rsa_oaep_md:sha256 \
  -pkeyopt rsa_mgf1_md:sha256 \
  -out "$recovery_tmp/ENCRYPTION_KEY"
```

Restore that value into Infisical Development `/rakazo/ENCRYPTION_KEY` through a
private operator session before starting API/worker against restored databases
and MinIO objects. Do not paste it into chat, commit it, or put it in command-line
arguments. Remove the temporary directory when finished; the shell trap does so
on exit. Rotating this key requires updating this recovery artifact and retaining
any old key material still needed by historical database/object backups.
