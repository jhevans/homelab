# Implementation Plan: 2026 Home Lab & Private Cloud

This plan breaks down the [ProjectPlan.md](../identity/ProjectPlan.md) into small, verifiable iterations. Each iteration follows the **Plan -> Act -> Validate** cycle.

## Iteration 1: AI "Learning-by-Doing" (The Cluster Chronicler)
**Goal:** Build a "throwaway" agent to bridge gaps in Secure Containers and RAG.

1. **Development (Workstation):**
   - [x] Write a minimal Python script using `kubernetes-client` to watch cluster events.
   - [x] Implement "Poor Man's RAG": Read a local JSON/Markdown file for app context.
   - [x] Test LLM integration: Send event + context to local Ollama API.
2. **Deployment (Cluster):**
   - [x] Containerize: Create a non-root Dockerfile.
   - [x] RBAC: Define `ServiceAccount`, `Role`, and `RoleBinding` (Read-only Events/Pods).
   - [x] Deploy: A simple `Deployment` in the `ai` namespace.
3. **Validation (Learning Outcomes):**
   - [x] **Secure Agency:** Verify the agent cannot delete or modify cluster resources (RBAC enforcement).
   - [x] **RAG Check:** Verify the narrative includes context from the docs (e.g., identifies "Authelia" as "SSO").
   - [x] **Narrative Quality:** View `kubectl logs` and see: *"Authelia (SSO) is now standing guard over the cluster."*

## Iteration 2: Critical Data Protection (Paperless-ngx)
**Goal:** Ensure the "Genuine Utility" data in Paperless is safe from total Mini PC failure.

1.  **Deploy Velero + Restic/Kopia:**
    - [/] Deploy Velero via Flux in `kubernetes/infrastructure/backup` (In Progress).
    - [ ] Configure Restic/Kopia for file-level backups of `local-path` Persistent Volumes (specifically for Paperless-ngx).
2.  **Backup Storage Location (BSL):**
    - [ ] **TBC:** Select and configure a primary local BSL (e.g., MinIO or external drive).
    - [x] **Verified:** Configured Cloudflare R2 as the secondary encrypted off-site BSL.
3.  **Validation (The "Simulated Disaster"):**
    - [ ] Delete the `productivity` namespace.
    - [ ] Restore it using Velero + Flux.
    - [ ] **Verified:** Verify data integrity of Paperless-ngx documents after restoration.

---

## 📋 Unprioritized Backlog

### Networking & Remote Access
- [ ] **WireGuard Deployment:** Deploy WireGuard as a K8s deployment/service or NixOS module.
- [ ] **Client Configuration:** Generate peer config for Android/Laptop.
- [ ] **Validation:** Connect from an external network and ping the Mini PC's internal IP.

### Technical Debt & Maintenance
- [ ] **Ultra-Paranoid Security Agent:** Create a dedicated agent for zero-trust analysis.
- [ ] **Grafana Security:** Rotate Grafana admin password to a SOPS-encrypted secret.
- [ ] **Update Monitoring:** Implement Renovate or Flux image automation for dependency audits.
- [ ] **Declarative Admin Setup:** Move Paperless-ngx admin credentials into a SOPS-encrypted secret.
- [ ] **Version Audit:** Perform exhaustive version review for every Helm chart and image.
- [ ] **Alerting:** Implement reliable alerting for mission-critical services.
- [ ] **Energy-Aware Scheduling:** Design workload shifting for "free energy" windows.

### Autonomous Research & Operations Center (AROC) - [DRAFT/TBC]
- [ ] **Phase 1: The Intelligent Foundation** (Inference Proxy, Vector DB, Event Bus, Registry).
- [ ] **Phase 2: The Agentic Workforce** (Dev, Auditor, Scout, Knowledge, Red Team Agents).
- [ ] **Phase 3: Daily Utility & "LifeOps"** (Curation, Finance, Memex, FinOps).
