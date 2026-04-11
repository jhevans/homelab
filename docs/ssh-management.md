# SSH Key Management Workflow

This project uses a **GitOps-native** approach to managing SSH keys, ensuring they are backed up securely and versioned alongside the infrastructure.

## 🔐 The "SOPS + Age" Pattern

1.  **Generation:** Keys are generated as Ed25519 for maximum security and minimal length.
2.  **Public Key:** Stored directly in the NixOS `configuration.nix` for the target host.
3.  **Private Key Backup:** Encrypted using `sops` with the project's **Age** key and stored in `secrets/ssh_backups.yaml`.
4.  **Local Storage:** The raw private key should be stored in the administrator's `~/.ssh/` directory and a password manager (e.g., Vaultwarden).

## 🛠️ Common Operations

### Extracting a Private Key from Backup
To recover a private key from the Git repository:

```bash
# Replace 'id_homelab_mini_pc' with the relevant key name
sops -d secrets/ssh_backups.yaml | sed -n '/-----BEGIN/,/-----END/p' | sed 's/^    //' > ~/.ssh/id_homelab_mini_pc
chmod 600 ~/.ssh/id_homelab_mini_pc
```

### Rotating a Key
1.  Generate a new key pair: `ssh-keygen -t ed25519 -f ./new_key`.
2.  Update the public key in the relevant `configuration.nix`.
3.  Update the encrypted backup:
    ```bash
    # Add to YAML
    sops secrets/ssh_backups.yaml
    ```
4.  Commit the changes and redeploy (or wait for Flux to reconcile).

## ⚠️ Security Reminders
- **Never** commit unencrypted private keys.
- **Never** share the Age private key (`~/.age/homelab.age`).
- **Always** use a passphrase for your local private keys.
