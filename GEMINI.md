# Gemini Project Instructions

This file contains foundational mandates and project-specific instructions for Gemini. These instructions take absolute precedence over general workflows.

## Project Overview
- **Name:** homelab
- **Description:** A unified, declarative Private Cloud providing a professional-grade development environment, privacy-focused service hosting, and an AI-augmented "Personal Intelligence Hub."
## Documentation Architecture (Declarative vs. Dynamic)
The documentation is organized by intent within the `docs/` directory to maintain a clean root and clear source of truth.
- **`docs/identity/`**: The "Soul" of the lab. High-level vision and strategy.
  - `ProjectPlan.md`: Authoritative architectural blueprint.
  - `PHILOSOPHY.md`: Guiding ethos and living principles.
  - `RISKS.md`: Identified technical observations and vulnerabilities.
  - `archive/AROC.md`: Archived initial brainstorm ideas for the agentic layer (Spitball/Non-prescriptive).
  - `NAS-DESIGN.md`: Strategy for stateful storage and high-speed networking.
- **`docs/registry/`**: The "Cold" Data. Technical specifications and state.
  - `IPAM.md`: Static IP assignments and network topology.
  - `Software.md`: Definitive software inventory and stack.
  - `Hardware.md`: Physical asset inventory and specifications.
- **`docs/workflow/`**: The "How". Active tasks and procedures.
  - `ImplementationPlan.md`: The phased execution roadmap (The SoT for current task status).
  - `STANDARDS.md`: Engineering, documentation, and YAGNI standards.
  - `manual-bootstrap-guide.md`: Steps for initial setup.
  - `ssh-management.md`: Procedures for secret/key handling.
- **`docs/memory/`**: The "Experience". Lessons learned and decision records.
  - `GOTCHAS.md`: Non-obvious behaviors, pitfalls, and architectural decision records.

## Engineering Standards
- **YAGNI & Pruning:** Adhere to the aggressive pruning and repository hygiene standards defined in `docs/workflow/STANDARDS.md`.
- **Surgical Updates:** Minimize changes to only what is necessary for the task.
- **Documentation:** Always update the relevant file in `docs/` after changes. Use the **Doc Housekeeper** skill to ensure cross-references remain valid.
- **Commits:**
  - Use **Gitmoji** for clear intent categorization.
  - Use the **imperative tense** (e.g., "Add feature" not "Added feature").
  - Focus on **why** a change is being made over what was changed.
  - Structure: A brief first-line headline followed by a bulleted list for additional context.
  - Propose a draft commit message for user approval.

## 🛡️ Safety & Data Integrity Mandates
- **Non-Destructive Validation:** NEVER delete the primary copy of "Genuine Utility" data to test a recovery system. Always prefer non-destructive validation methods, such as:
  - Restoring to a different namespace/prefix.
  - Verifying file checksums within the backup.
  - Cloning volumes to a test environment.
- **Verification of Out-of-Band Backups:** Before performing any operation that could result in data loss, verify that at least one independent, out-of-band backup (e.g., manual export, external drive) exists and is accessible.
- **Retention of Validation Artifacts:** Always keep backup/restore logs and objects until the user has manually verified the success of the operation.

## Workflow Mandates
- **Surgical Updates:** Minimize changes to only what is necessary for the task.
- **Validation:** 
  - Always verify changes with tests and linting.
  - **Kubernetes Validation:** Before committing any changes to the `kubernetes/` directory, always run `flux build kustomization <name> --path <path>` (e.g., `flux build kustomization apps --path kubernetes/apps`) to ensure manifests are syntactically correct and correctly linked.
  - **Dashboard Maintenance:** Whenever a new user-facing service is added to the cluster, its corresponding entry (name, icon, and URL) must be added to the `homepage` configuration in `kubernetes/apps/dashboard/homepage/`.
  - **Secret Management:** One file per secret in `secrets/`. Never group multiple distinct secrets (e.g., SSH keys for different hosts) in one file to prevent SOPS metadata conflicts.
  - **NixOS Hardware:** Always commit the auto-generated `hardware-configuration.nix` for each host as a "hardware lockfile" for 1:1 reproducibility.
