# ⚠️ Project Gotchas & Troubleshooting

This document tracks non-obvious behaviors, environmental constraints, and common pitfalls encountered in this homelab.

---

## 🌊 Flux API Versions
- **Issue:** Using `v1beta2` for `HelmRepository` or `v2beta1` for `HelmRelease` may result in a "no matches for kind" error.
- **Root Cause:** The Flux installation on the current cluster (likely an older or specific version) expects `source.toolkit.fluxcd.io/v1` and `helm.toolkit.fluxcd.io/v2`.
- **Solution:** Always verify the active API versions using `kubectl get helmrelease -A -o yaml | head -n 5` before creating new manifests.

## 🚦 Traefik Middleware API Versions
- **Issue:** Using `traefik.containo.us/v1alpha1` for `Middleware` may result in a "no matches for kind" error.
- **Root Cause:** The Traefik installation on the current cluster (v2.x or v3.x) uses the `traefik.io/v1alpha1` API group.
- **Solution:** Always verify the available API resources using `kubectl api-resources | grep middleware` before creating new manifests.

## 📁 ConfigMap Namespaces in Kustomize
- **Issue:** `configMapGenerator` without an explicit `namespace` in the `Kustomization` file may cause reconciliation failures if the parent kustomization doesn't propagate the namespace correctly.
- **Solution:** Explicitly set `namespace: <name>` in the `kustomization.yaml` of the application directory.

## 🔄 Local K3d Context
- **Issue:** The local `kubeconfig` for `k3d` may resolve to `host.docker.internal` which might be unreachable from the host environment.
- **Solution:** Manually update the server address to `127.0.0.1` in the `kubeconfig` if connection issues occur.
