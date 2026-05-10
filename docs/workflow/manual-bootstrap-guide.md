# 🛠️ Manual Bootstrap Guide: New NixOS Node

This guide provides the minimal steps to provision a new NixOS node using the **Graphical Installer**.

## Phase 0: Preparation (Workstation)
1.  **ISO:** Download the **NixOS Graphical Installer (Plasma/Gnome)**.
2.  **Flash:** Use **GPT** and **DD Image Mode** (e.g., via Rufus).
3.  **Secrets:** Ensure SSH and GitHub Deploy keys are generated in `secrets/`.

---

## Phase 1: Initial OS Install (Target Host)
1.  **Boot:** Boot from the media and select the **Graphical Installer**.
2.  **Run Wizard:** Click the **"Install NixOS"** icon on the desktop.
    *   Follow the prompts for partitioning (Erase disk) and users.
    *   **Crucial:** Once the installer finishes, **DO NOT REBOOT YET**.

---

## Phase 2: Remote Configuration (Target Host Terminal)
1.  **Enable SSH:**
    *   Open a terminal on the target host.
    *   Run `sudo nano /etc/nixos/configuration.nix`.
    *   Add: `services.openssh.enable = true;`.
    *   Apply: `sudo nixos-rebuild switch`.
    *   Set temp password: `sudo passwd nixos`.
2.  **Hardware Scan:**
    *   `cat /etc/nixos/hardware-configuration.nix`.
    *   **Action:** Copy this text and provide it to the Gemini agent to commit to the repository.

---

## Phase 3: Repository Setup & Reboot (Target Host Terminal)
1.  **Setup GitOps Repo:**
    ```bash
    sudo git clone https://github.com/jhevans/homelab.git /etc/nixos/homelab
    sudo ln -sf /etc/nixos/homelab/nixos/hosts/<HOSTNAME>/configuration.nix /etc/nixos/configuration.nix
    ```
2.  **Apply Final Config:**
    `sudo nixos-rebuild switch`
3.  **Reboot:** `sudo reboot`

---

## Phase 4: Verification (Workstation)
1.  **Verify Access:** `ssh john@<STATIC_IP>` (using your `id_control_plane_01` key).
2.  **Bootstrap Flux:** (Follow host-specific `README.md` for `flux bootstrap`).
