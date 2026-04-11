# ⚠️ Project Gotchas & Troubleshooting

This document tracks non-obvious behaviors, environmental constraints, and common pitfalls encountered in this homelab.

---
## 📁 Secret Management: One File Per Secret
- **Decision:** As of 2026-04-11, the project has transitioned from a single `ssh_backups.yaml` to individual files in the `secrets/` directory (e.g., `secrets/host_purpose.yaml`).
- **Reasoning:** Prevents SOPS metadata conflicts, allows for surgical decryption, and provides cleaner Git diffs for security auditing.
- **Workflow:** When adding a new secret, always create a fresh YAML file with a single `private_key` or `value` field and encrypt it individually. See `docs/ssh-management.md` for the full procedure.

## 🧱 NixOS: Committing hardware-configuration.nix
- **Decision:** Always commit the auto-generated `hardware-configuration.nix` for each host.
- **Reasoning:** It acts as a "hardware lockfile," capturing specific UUIDs and kernel modules required for a 1:1 reproducible rebuild. It is essential for disaster recovery (software-level) without needing a fresh hardware scan.
- **Hardware Change:** If the underlying hardware is replaced, a new scan must be performed, and the file in Git must be updated to reflect the new "Hardware DNA."

## 🌊 Flux API Versions
...
- **Issue:** Using `v1beta2` for `HelmRepository` or `v2beta1` for `HelmRelease` may result in a "no matches for kind" error.
- **Root Cause:** The Flux installation on the current cluster (likely an older or specific version) expects `source.toolkit.fluxcd.io/v1` and `helm.toolkit.fluxcd.io/v2`.
- **Solution:** Always verify the active API versions using `kubectl get helmrelease -A -o yaml | head -n 5` before creating new manifests.

## 🚦 Traefik Middleware API Versions
- **Issue:** Using `traefik.containo.us/v1alpha1` for `Middleware` may result in a "no matches for kind" error.
- **Root Cause:** The Traefik installation on the current cluster (v2.x or v3.x) uses the `traefik.io/v1alpha1` API group.
- **Solution:** Always verify the available API resources using `kubectl api-resources | grep middleware` before creating new manifests.

## 🔐 Authelia v0.9.1+ Secret Keys
- **Issue:** Authelia pod stuck in `ContainerCreating` with `MountVolume.SetUp failed` error.
- **Root Cause:** The 0.9.1 chart expects specific key names in the `existingSecret` for its internal mounts.
- **Solution:** Ensure the secret contains `identity_validation.reset_password.jwt.hmac.key`, `session.encryption.key`, and `storage.encryption.key`.

## 📁 ConfigMap Namespaces in Kustomize
- **Issue:** `configMapGenerator` without an explicit `namespace` in the `Kustomization` file may cause reconciliation failures if the parent kustomization doesn't propagate the namespace correctly.
- **Solution:** Explicitly set `namespace: <name>` in the `kustomization.yaml` of the application directory.

## 🔄 Local K3d Context
- **Issue:** The local `kubeconfig` for `k3d` may resolve to `host.docker.internal` which might be unreachable from the host environment.
- **Solution:** Manually update the server address to `127.0.0.1` in the `kubeconfig` if connection issues occur.

## 📡 Networking: TP-Link Deco /22 Subnet
- **Behavior:** TP-Link Deco mesh systems often use a large `/22` subnet (e.g., `192.168.68.0/22`).
- **Gotcha:** This covers the range `192.168.68.0` through `192.168.71.255`. If using static IPs, ensure the gateway is correctly set (usually `192.168.68.1`) and the prefix length is `22` in NixOS networking.
