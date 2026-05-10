# Implementation Plan: 2026 Home Lab & Private Cloud

This plan breaks down the [ProjectPlan.md](../identity/ProjectPlan.md) into small, verifiable iterations. Each iteration follows the **Plan -> Act -> Validate** cycle.

## Iteration 1: Critical Data Protection (Paperless-ngx)
**Goal:** Ensure the "Genuine Utility" data in Paperless is safe from total Mini PC failure.

1.  **Deploy Velero + Restic/Kopia:**
    - [ ] Deploy Velero via Flux in `kubernetes/infrastructure/backup`.
    - [ ] Configure Restic/Kopia for file-level backups of `local-path` Persistent Volumes (specifically for Paperless-ngx).
2.  **Backup Storage Location (BSL):**
    - [ ] **TBC:** Select and configure a primary local BSL (e.g., MinIO or external drive).
    - [ ] **TBC:** Select and configure a secondary encrypted off-site BSL (e.g., Cloudflare R2 or Backblaze B2).
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
