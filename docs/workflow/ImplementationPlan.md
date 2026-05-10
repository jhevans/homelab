# Implementation Plan: 2026 Home Lab & Private Cloud

This plan breaks down the [ProjectPlan.md](../identity/ProjectPlan.md) into small, verifiable iterations. Each iteration follows the **Plan -> Act -> Validate** cycle.

## Iteration 3: Observability (ASAP)
**Goal:** Monitor cluster health and performance from the start.

1.  **Prometheus & Grafana:**
    - [x] Deploy the `kube-prometheus-stack` via Helm in `/kubernetes/infrastructure`.
    - [x] **Verified:** Grafana is Running and accessible via Ingress.
2.  **Uptime Kuma:**
    - [x] **Verified:** Uptime Kuma is Running and accessible via Ingress.
3.  **Loki & Promtail (Logging):**
    - [x] **Verified:** Loki is Running (verified via PVC and pod logs).
4.  **Validation:**
    - [x] **Verified:** Access Grafana dashboards and see CPU/RAM metrics for the K3d sandbox nodes.
    - [x] **Verified:** Query pod logs in the Grafana "Explore" view using the Loki data source.

## Iteration 5: WireGuard & Remote Access
**Goal:** Securely access the cluster from outside the local network.

1.  **WireGuard Deployment:**
    - [ ] Deploy WireGuard as a K8s deployment/service or NixOS module.
2.  **Client Configuration:**
    - [ ] Generate peer config for Android/Laptop.
3.  **Validation:**
    - [ ] Connect from an external network.
    - [ ] Ping the Mini PC's internal IP or access `adguard.lab.local` via the VPN.

## Iteration 6: GPU Integration & AI (The Heavy Lifter)
**Goal:** Add the Desktop as a worker node and enable AI services.

1.  **Desktop NixOS Config:**
    - [ ] Create `nixos/hosts/desktop/configuration.nix`.
    - [ ] Enable NVIDIA drivers and NVIDIA Container Toolkit.
    - [ ] Enable K3s in `agent` mode.
2.  **K8s Taints & Labels:**
    - [ ] Label the desktop node: `nvidia.com/gpu=true`.
    - [ ] Add a taint for GPU-only workloads.
3.  **Ollama Deployment:**
    - [x] **Verified:** Ollama-cpu is Running (responding via Ingress). Note: Flux reports a Helm timeout during PVC provision, but service is functional.
    - [x] **Verified:** Open WebUI is Running and accessible at `ai.lab.local`.
    - [ ] **NEW: Install Google Gemma.** Configure Ollama to pull and serve the Gemma model family.
4.  **Validation:**
    - [ ] `kubectl describe node desktop` shows the GPU resource.
    - [ ] Run a test LLM query and verify GPU utilization.

## Iteration 7: Personal Services (The "Home" in Home Lab)
**Goal:** Deploy daily-use applications.

1.  **Forgejo:**
    - [x] **Verified:** Forgejo is Running and responding with HTTP 200 via Ingress.
2.  **Paperless-ngx:**
    - [x] **Verified:** Paperless-ngx is Running and responding with HTTP 302 (Redirect to login) via Ingress.
    - [ ] **DEBUG:** Resolve "secret not found" and Redis connectivity issues. Current workaround is bypassing the buggy Helm injection logic.
    - [ ] **NEXT STEP:** Investigate implementing shared standalone Redis and Postgres instances (e.g., using CloudNativePG) to replace fragile per-app subcharts ("Fix Once, Fix Everywhere" approach).
3.  **Home Assistant:**
    - [ ] Deploy with necessary hardware passthrough.
3.  **Jellyfin:**
    - [ ] Deploy with GPU acceleration enabled.
4.  **Immich:**
    - [ ] Setup Postgres and Redis dependencies.
5.  **Validation:**
    - [ ] Login to Home Assistant and discover local devices.
    - [ ] Stream a video from Jellyfin and verify hardware transcoding.

## Iteration 8: Unified Authentication (SSO) & Integration
**Goal:** Centralize user management and enable SSO across all lab services.

1.  **Deploy Authelia:**
    - [x] **Verified:** Authelia v0.11.5 is Running and accessible at `http://auth.lab.local`.
    - [x] **Verified:** Users can authenticate via the portal using credentials in `configmaps.yaml`.
2.  **Traefik Integration (ForwardAuth):**
    - [ ] **NEXT:** Configure Traefik `ForwardAuth` Middleware to point to the Authelia verify API.
    - [ ] **NEXT:** Update Ingress resources to use the `authelia` middleware.
3.  **Application Integration (Paperless-ngx):**
    - [ ] **NEXT:** Enable "Remote User" authentication in Paperless-ngx.
    - [ ] **NEXT:** Configure header passing (Remote-User, Remote-Groups) from Authelia to Paperless.
4.  **Security Hardening:**
    - [ ] Enforce 2FA/MFA (WebAuthn/TOTP) for all services.
    - [ ] Implement Geoblocking or "Level 2" authentication for external access.
5.  **Validation:**
    - [ ] Access `paperless.lab.local` and be redirected to Authelia.
    - [ ] Log in via Authelia and be automatically logged into Paperless with the correct user profile.

## Iteration 9: Disaster Recovery & Data Durability
**Goal:** Ensure all persistent data is backed up and recoverable from total cluster failure.

1.  **Deploy Velero + Restic/Kopia:**
    - [ ] Deploy Velero via Flux in `kubernetes/infrastructure/backup`.
    - [ ] Configure Restic/Kopia for file-level backups of `local-path` Persistent Volumes.
2.  **Backup Storage Location (BSL):**
    - [ ] Configure a primary local BSL (e.g., MinIO or external drive).
    - [ ] Configure a secondary encrypted off-site BSL (e.g., Cloudflare R2 or Backblaze B2).
3.  **Validation:**
    - [ ] Perform a "Simulated Disaster": Delete a namespace (e.g., `productivity`) and restore it using Velero + Flux.
    - [ ] Verify data integrity of Paperless-ngx documents after restoration.

### Future Backlog & Technical Debt
- [x] **NEW: Deploy Paperless-ngx.** Setup OCR-indexed document management as the "Private Memex" base.
### Autonomous Research & Operations Center (AROC) - [DRAFT/TBC]

The potential, phased implementation of the agentic workforce is detailed in the **[AROC.md](../identity/AROC.md) (TBC)** brainstorm document.

* [ ] **Phase 1: The Intelligent Foundation** (Inference Proxy, Vector DB, Event Bus, Registry).
* [ ] **Phase 2: The Agentic Workforce** (Dev, Auditor, Scout, Knowledge, Red Team Agents).
* [ ] **Phase 3: Daily Utility & "LifeOps"** (Curation, Finance, Memex, FinOps).

### Technical Debt & Maintenance
- **Security:**
  - [ ] **NEW: Create Ultra-Paranoid Security Agent.** A dedicated agent to perform continuous, "zero-trust" analysis of the cluster, secrets, and NixOS configurations.
  - [ ] Rotate Grafana admin password from default (`prom-operator`) to a SOPS-encrypted secret.
  - [ ] **Backlog:** Dedicated security posture review and hardening.
- **Maintenance:**
  - [ ] **NEW: Establish Regular Update Monitoring Mechanism.** Implement a system (e.g., Renovate, Flux image automation, or a dedicated agent audit) to regularly check for and notify/apply updates for all Helm charts and Docker images.
  - [ ] **NEW: Declarative Admin Setup.** Move Paperless-ngx admin credentials into a SOPS-encrypted secret to ensure zero-touch recovery after cluster failure.
  - [ ] **Backlog:** Troubleshoot and restore EmonHP (Heat Pump monitor) network connectivity.
  - [ ] **CRITICAL: Exhaustive Version Audit.** Review every Helm chart and container image in the repository. Perform a live web search for each to ensure we are on the latest stable version. **DO NOT RELY ON MEMORY.**
  - [ ] **Backlog:** Implement robust, reliable alerting for all mission-critical services.
  - [ ] **Backlog:** Design and implement energy-aware scheduling/workload shifting (e.g., maximize "free energy" usage).

