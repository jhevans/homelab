# Implementation Plan: 2026 Home Lab & Private Cloud

This plan breaks down the [ProjectPlan.md](../identity/ProjectPlan.md) into small, verifiable iterations. Each iteration follows the **Plan -> Act -> Validate** cycle.

## Iteration 1: AI "Learning-by-Doing" (The Cluster Chronicler)
**Goal:** Build an agent to bridge gaps in Secure Containers and RAG.

1. **Development (Workstation):**
   - [x] Write a minimal Python script using `kubernetes-client` to watch cluster events.
   - [x] Implement "Poor Man's RAG": Read a local JSON/Markdown file for app context.
   - [x] Test LLM integration: Send event + context to local Ollama API.
   - [x] **Refinement:** Implement periodic (6h) summarization to reduce noise.
2. **Deployment (Cluster):**
   - [x] Containerize: Create a non-root Dockerfile.
   - [x] RBAC: Define `ServiceAccount`, `Role`, and `RoleBinding` (Read-only Events/Pods).
   - [x] Deploy: A `CronJob` in the `ai` namespace running every 6 hours.
3. **Validation (Learning Outcomes):**
   - [x] **Secure Agency:** Verify the agent cannot delete or modify cluster resources.
   - [x] **Summary Quality:** Verify the report identifies high-value events while ignoring routine noise.

## Iteration 2: Critical Data Protection (Paperless-ngx)
**Goal:** Ensure the "Genuine Utility" data in Paperless is safe from total Mini PC failure.

1.  **Deploy Velero + Restic/Kopia:**
    - [x] Deploy Velero via Flux in `kubernetes/infrastructure/backup`.
    - [x] **Verified:** Configured Cloudflare R2 as the primary off-site BSL.
    - [x] **Verified:** Enabled `defaultVolumesToFsBackup` in Velero.
    - [x] **Verified:** Implemented `cluster-daily` schedule for all non-system namespaces.
2.  **Validation (The "Simulated Disaster"):**
    - [x] Delete the `productivity` namespace.
    - [x] Restore it using Velero + Flux.
    - [x] **Verified:** Data integrity of Paperless-ngx documents and PostgreSQL database confirmed after restoration.

## Iteration 3: The Persistent Agent Hub (Hermes)
**Goal:** Deploy a self-improving, durable agent with persistent memory and secure sandboxing.

1. **Deployment (Cluster):**
   - [x] Storage: Create 5Gi PVC for persistent memory and skills.
   - [x] Security: Define read-only RBAC ServiceAccount.
   - [x] Hub: Deploy StatefulSet with Messaging Gateway and Web UI.
   - [x] Sandbox: Integrate Docker-in-Docker (DIND) sidecar for secure execution.
2. **Integration:**
   - [x] Ingress: Expose via `hermes.lab.local` (Temporarily unauthenticated).
   - [ ] **Security:** Re-enable Authelia authentication for `hermes.lab.local` once the global SSO setup is finalized.
   - [x] DNS: Added routing rule to AdGuard Home.
   - [x] Dashboard: Added to Homepage portal.

## Iteration 4: Cluster Observability & Visualization
**Goal:** Enhance cluster visibility with real-time visualization.

1. **Deployment (Cluster):**
   - [x] RBAC: Defined ClusterRole and ServiceAccount for `kube-aura`.
   - [x] Deploy: Create raw Kubernetes manifests (Deployment, Service, Ingress) for `kube-aura`.
   - [x] Integration: Expose via `kube-aura.lab.local`.
   - [x] Dashboard: Added to Homepage portal.

---

## 📋 Unprioritized Backlog

### Networking & Remote Access
- [ ] **WireGuard Deployment:** Deploy WireGuard as a K8s deployment/service or NixOS module.
- [ ] **Client Configuration:** Generate peer config for Android/Laptop.
- [ ] **Validation:** Connect from an external network and ping the Mini PC's internal IP.

### Data Protection (Future)
- [ ] **Local Network Tier:** Configure a secondary backup tier to the NAS once it is commissioned (completes 3-2-1 strategy).

### Technical Debt & Maintenance
- [ ] **Automated Backup Validation:** Design a scheduled agent or workflow to perform regular, non-destructive restore tests (using namespace mapping) for all critical namespaces to verify backup integrity.
- [ ] **Ultra-Paranoid Security Agent:** Create a dedicated agent for zero-trust analysis.
- [ ] **Grafana Security:** Rotate Grafana admin password to a SOPS-encrypted secret.
- [ ] **Update Monitoring:** Implement Renovate or Flux image automation for dependency audits.
- [ ] **Declarative Admin Setup:** Move Paperless-ngx admin credentials into a SOPS-encrypted secret.
- [ ] **Version Audit:** Perform exhaustive version review for every Helm chart and image.
- [ ] **Alerting:** Implement reliable alerting for mission-critical services.
- [ ] **Energy-Aware Scheduling:** Design workload shifting for "free energy" windows.

### Persistent Agent Hub (Hermes) Refinements
- [ ] **Development Sandbox:** Provision a `hermes-dev` instance to safely test new LLM providers (Ollama), skills, and experimental configurations without impacting production.
- [ ] **Unified SSO:** Integrate Hermes with Authelia once global SSO standards are finalized.

### Autonomous Research & Operations Center (AROC) - [DRAFT/TBC]
- [ ] **Phase 1: The Intelligent Foundation** (Inference Proxy, Vector DB, Event Bus, Registry).
- [ ] **Phase 2: The Agentic Workforce** (Dev, Auditor, Scout, Knowledge, Red Team Agents).
- [ ] **Phase 3: Daily Utility & "LifeOps"** (Curation, Finance, Memex, FinOps).
