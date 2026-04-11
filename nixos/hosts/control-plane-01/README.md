# 🛠️ NixOS Bootstrap Instructions: control-plane-01

This is the manual for turning this code into a live server. **Read this if the session is lost.**

### **Prerequisites:**
1.  **Hardware:** HP EliteDesk Mini PC connected to the network.
2.  **USB:** A bootable NixOS 23.11+ Installer USB.
3.  **SSH Keys:** Your public key is already in `configuration.nix`. To set up your keys, run:
    ```bash
    # Extract Main SSH Key
    sops -d secrets/control_plane_01_ssh.yaml | sed -n '/-----BEGIN/,/-----END/p' | sed 's/^    //' > ~/.ssh/id_homelab_mini_pc
    chmod 600 ~/.ssh/id_homelab_mini_pc

    # Extract GitHub Deploy Key
    sops -d secrets/control_plane_01_github_deploy.yaml | sed -n '/-----BEGIN/,/-----END/p' | sed 's/^    //' > ~/.ssh/id_github_deploy_control_plane_01
    chmod 600 ~/.ssh/id_github_deploy_control_plane_01
    ```
    **Note:** Ensure the GitHub Deploy Key is added to your repository's "Deploy Keys" in GitHub settings with read-only access.

### **Phase 1: Initial Install**
1.  Boot from the NixOS USB.
2.  Run the partitioner (standard UEFI layout):
    ```bash
    nixos-generate-config --root /mnt
    ```
3.  **CRITICAL:** Copy the generated `/mnt/etc/nixos/hardware-configuration.nix` into this repository at `nixos/hosts/control-plane-01/hardware-configuration.nix`.
4.  Clone this repository onto the installer:
    ```bash
    git clone https://github.com/jhevans/homelab.git /mnt/etc/nixos/homelab
    ```
5.  Link your configuration:
    ```bash
    ln -sf /mnt/etc/nixos/homelab/nixos/hosts/control-plane-01/configuration.nix /mnt/etc/nixos/configuration.nix
    ```
6.  Install:
    ```bash
    nixos-install
    reboot
    ```

### **Phase 2: K8s Takeover**
1.  Once the machine is up, SSH into `john@192.168.68.10`.
2.  Verify K3s is running: `kubectl get nodes`.
3.  **Bootstrap Flux:**
    ```bash
    flux bootstrap github \
      --owner=jhevans \
      --repository=homelab \
      --branch=main \
      --path=./kubernetes/flux
    ```

---
**Status:** Initial `configuration.nix` created. **Action Required:** Replace SSH key placeholder before installation.
