# Gemini Project Instructions

This file contains foundational mandates and project-specific instructions for Gemini. These instructions take absolute precedence over general workflows.

## Project Overview
- **Name:** homelab
- **Description:** A unified, declarative Private Cloud providing a professional-grade development environment, privacy-focused service hosting, and an AI-augmented "Personal Intelligence Hub."
- **Foundational Mandates:**
  - [ProjectPlan.md](./ProjectPlan.md): The authoritative architectural blueprint.
  - [ImplementationPlan.md](./ImplementationPlan.md): The phased execution roadmap.
  - [PHILOSOPHY.md](./PHILOSOPHY.md): The project's guiding ethos and living principles.
- **Mandate:** All changes must align with these principles and implementation phases. Unless explicitly marked as a "firm unbreakable principle", the instructions in this and other files should be treated as advice, guidance, or our current best knowledge. This is a living document that will evolve.

## Project Ethos & Guiding Philosophy (Living Guidance)
The following principles reflect our current thinking and should guide all improvements to the homelab:
- **Stability-First Innovation:** Stability and reliability are the foundation for all future innovation. Focus on addressing the fundamentals to reduce friction.
- **Absolute Sovereignty:** Aim for 100% local sovereignty (no external dependencies for core functions) with off-site cloud backups strictly for disaster recovery.
- **Reliable Alerting:** Mission-critical services must have reliable alerting to ensure the project's long-term health.
- **Human-in-the-Loop Transparency:** All changes should be PR-based, well-documented, and explained by agents to ensure the owner understands the system inside out.
- **Energy-Aware Performance:** Maximize resource usage when electricity is "free" (e.g., solar surplus) and prioritize efficiency at other times, while remaining able to deliver performance on demand.
- **Evolving Security Posture:** Security is a dynamic focus that requires constant refinement and dedicated attention in the backlog.

## Engineering Standards
- **Style:** Adhere to existing naming conventions and architectural patterns.
- **Testing:** Always include tests for new features or bug fixes.
- **Documentation:** Keep documentation up-to-date with code changes.
- **Commits:**
  - Use **Gitmoji** for clear intent categorization.
  - Use the **imperative tense** (e.g., "Add feature" not "Added feature").
  - Focus on **why** a change is being made over what was changed.
  - Structure: A brief first-line headline followed by a bulleted list for additional context.
  - Propose a draft commit message for user approval.

## Workflow Mandates
- **Surgical Updates:** Minimize changes to only what is necessary for the task.
- **Validation:** 
  - Always verify changes with tests and linting.
  - **Kubernetes Validation:** Before committing any changes to the `kubernetes/` directory, always run `flux build kustomization <name> --path <path>` (e.g., `flux build kustomization apps --path kubernetes/apps`) to ensure manifests are syntactically correct and correctly linked.
  - **Dashboard Maintenance:** Whenever a new user-facing service is added to the cluster, its corresponding entry (name, icon, and URL) must be added to the `homepage` configuration in `kubernetes/apps/dashboard/homepage/`.
