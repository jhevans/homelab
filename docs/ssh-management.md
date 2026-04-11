# SSH Key Management Workflow

This project uses a **GitOps-native** approach to managing SSH keys, ensuring they are backed up securely and versioned alongside the infrastructure.

## 🔐 The "One File Per Secret" Pattern

1.  **Generation:** Keys are generated as Ed25519 for maximum security and minimal length.
2.  **Public Key:** Stored directly in the NixOS `configuration.nix` for the target host (or on GitHub as a Deploy Key).
3.  **Private Key Backup:** Each private key is encrypted individually using `sops` and stored in its own file in the `secrets/` directory.
    - Example: `secrets/control_plane_01_ssh.yaml`
    - Example: `secrets/control_plane_01_github_deploy.yaml`
4.  **Local Storage:** The raw private key should be stored in the administrator's `~/.ssh/` directory and a password manager (e.g., Vaultwarden).

## 🛠️ Common Operations

### Extracting a Private Key from Backup
To recover a private key from the Git repository:

```bash
# Replace 'control_plane_01_ssh.yaml' with the relevant file
sops -d secrets/control_plane_01_ssh.yaml | sed -n '/-----BEGIN/,/-----END/p' | sed 's/^    //' > ~/.ssh/id_homelab_mini_pc
chmod 600 ~/.ssh/id_homelab_mini_pc
```

### Rotating a Key
1.  Generate a new key pair: `ssh-keygen -t ed25519 -f ./new_key`.
2.  Update the public key in the relevant `configuration.nix` or GitHub.
3.  Create/Update the individual encrypted file:
    ```bash
    printf "private_key: |\n" > temp.yaml
    sed 's/^/  /' ./new_key >> temp.yaml
    sops --encrypt temp.yaml > secrets/host_name_purpose.yaml
    rm temp.yaml ./new_key*
    ```
4.  Commit the changes and redeploy (or wait for Flux to reconcile).

## ⚠️ Security Reminders
- **Never** commit unencrypted private keys.
- **One File Per Secret:** Avoid appending secrets to a single large blob.
- **Never** share the Age private key (`~/.age/homelab.age`).
- **Always** use a passphrase for your local private keys.
