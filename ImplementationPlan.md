# Implementation Plan: 2026 Home Lab & Private Cloud

This plan breaks down the [ProjectPlan.md](./ProjectPlan.md) into small, verifiable iterations. Each iteration follows the **Plan -> Act -> Validate** cycle.

## Iteration 1: Repository Structure & Sandbox Bootstrap
**Goal:** Establish the GitOps repository and a local K3d cluster for testing.

1.  **Repository Setup:**
    - [x] Initialize directory structure: `/kubernetes/apps`, `/kubernetes/flux`, `/kubernetes/infrastructure`, `/nixos/hosts`, `/nixos/modules`.
2.  **K3d Cluster Creation:**
    - [x] Create a local cluster: `k3d cluster create homelab-sandbox --port "8080:80@loadbalancer" --port "8443:443@loadbalancer"`.
3.  **Secret Management (SOPS + Age):**
    - [x] Install `sops` and `age` CLI tools.
    - [x] Generate an Age key pair for the cluster.
    - [x] Create a Kubernetes secret in the cluster containing the Age private key for Flux to use.
4.  **FluxCD Bootstrap:**
    - [x] Install Flux CLI.
    - [x] Bootstrap Flux into the `homelab-sandbox` cluster using the GitHub repository.
5.  **Validation:**
    - [x] `flux get sources git` shows successful reconciliation.
    - [x] `kubectl get nodes` shows the K3d node(s).

## Iteration 2: Internal DNS & Ingress
**Goal:** Setup local DNS resolution and routing within the sandbox.

1.  **Deploy AdGuard Home/Pi-hole:**
    - [x] Create a `HelmRelease` for AdGuard Home in `/kubernetes/apps/networking`.
    - [x] Configure basic DNS and Web UI settings.
    - [x] Verify pod health and reachability.
2.  **Configure Ingress (Traefik):**
    - [ ] Leverage the built-in Traefik Ingress controller in K3s/K3d.
    - [ ] Create `Ingress` resources to expose AdGuard Home (`adguard.lab.local`) and Headlamp (`headlamp.lab.local`).
3.  **Validation:**
    - [ ] Access the AdGuard Home UI via `http://adguard.lab.local:8080`.
    - [ ] Access the Headlamp UI via `http://headlamp.lab.local:8080`.
    - [ ] Verify `curl -H "Host: headlamp.lab.local" localhost:8080` routes correctly.

## Iteration 3: Observability (ASAP)
**Goal:** Monitor cluster health and performance from the start.

1.  **Prometheus & Grafana:**
    - [x] Deploy the `kube-prometheus-stack` via Helm in `/kubernetes/infrastructure`.
2.  **Uptime Kuma:**
    - [x] Deploy Uptime Kuma to monitor service availability.
3.  **Loki & Promtail (Logging):**
    - [x] Deploy the `loki-stack` to collect and store logs from all pods.
4.  **Validation:**
    - [ ] Access Grafana dashboards and see CPU/RAM metrics for the K3d sandbox nodes.
    - [ ] Query pod logs in the Grafana "Explore" view using the Loki data source.
    - [x] Configure a test alert in Uptime Kuma.

## Iteration 4: The NixOS Core (Mini PC)
**Goal:** Provision the primary NixOS node and K3s control plane.

1.  **Base NixOS Config:**
    - [ ] Create `nixos/hosts/mini-pc/configuration.nix`.
    - [ ] Enable K3s in `server` mode.
2.  **Hardware Optimization:**
    - [ ] Configure power management and SSH access.
3.  **Validation:**
    - [ ] Boot Mini PC from NixOS installer, apply configuration.
    - [ ] Verify `kubectl get nodes` on the Mini PC shows itself as `Ready`.
    - [ ] Verify Prometheus starts scraping metrics from the new node.

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
    - [ ] Deploy Ollama with GPU resource requests.
4.  **Validation:**
    - [ ] `kubectl describe node desktop` shows the GPU resource.
    - [ ] Run a test LLM query and verify GPU utilization.

## Iteration 7: Personal Services (The "Home" in Home Lab)
**Goal:** Deploy daily-use applications.

1.  **Forgejo:**
    - [x] Deploy Forgejo as the internal Git forge.
2.  **Home Assistant:**
    - [ ] Deploy with necessary hardware passthrough.
3.  **Jellyfin:**
    - [ ] Deploy with GPU acceleration enabled.
4.  **Immich:**
    - [ ] Setup Postgres and Redis dependencies.
5.  **Validation:**
    - [ ] Login to Home Assistant and discover local devices.
    - [ ] Stream a video from Jellyfin and verify hardware transcoding.

## Iteration 8: Unified Authentication (SSO)
**Goal:** Centralize user management and enable SSO across all lab services.

1.  **Deploy Authentik or Authelia:**
    - [ ] Research and select between Authentik (all-in-one, feature-rich) or Authelia (lightweight, simple).
    - [ ] Deploy via Helm in `/kubernetes/apps/networking`.
    - [ ] Configure a persistent database (Postgres) and Redis cache.
2.  **Identity Provider Integration:**
    - [ ] Configure LDAP or OIDC providers.
    - [ ] Integrate with Forgejo, Grafana, and AdGuard Home.
3.  **Security Hardening:**
    - [ ] Enforce 2FA/MFA (WebAuthn/TOTP) for all services.
    - [ ] Implement Geoblocking or "Level 2" authentication for external access.
4.  **Validation:**
    - [ ] Successfully login to Forgejo using the SSO provider.
    - [ ] Verify that unauthenticated requests to protected services are redirected to the auth portal.

## Future Backlog & Technical Debt
### Autonomous Research & Operations Center (AROC) - [DRAFT/TBC]
The potential, phased implementation of the agentic workforce is detailed in the **[AROC.md](./AROC.md) (TBC)** brainstorm document.

* [ ] **Phase 1: The Intelligent Foundation** (Inference Proxy, Vector DB, Event Bus, Registry).
* [ ] **Phase 2: The Agentic Workforce** (Dev, Auditor, Scout, Knowledge, Red Team Agents).
* [ ] **Phase 3: Daily Utility & "LifeOps"** (Curation, Finance, Memex, FinOps).

### Technical Debt & Maintenance
- **Security:**
  - [ ] Rotate Grafana admin password from default (`prom-operator`) to a SOPS-encrypted secret.
  - [ ] **Backlog:** Dedicated security posture review and hardening.
- **Maintenance:**
  - [ ] **CRITICAL: Exhaustive Version Audit.** Review every Helm chart and container image in the repository. Perform a live web search for each to ensure we are on the latest stable version. **DO NOT RELY ON MEMORY.**
  - [ ] Configure automated backups for Postgres/Redis.
  - [ ] **Backlog:** Implement robust, reliable alerting for all mission-critical services.
  - [ ] **Backlog:** Design and implement energy-aware scheduling/workload shifting (e.g., maximize "free energy" usage).

