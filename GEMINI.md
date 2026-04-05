# Gemini Project Instructions

This file contains foundational mandates and project-specific instructions for Gemini. These instructions take absolute precedence over general workflows.

## Project Overview
- **Name:** homelab
- **Description:** [Add description here]
- **Foundational Mandates:**
  - [ProjectPlan.md](./ProjectPlan.md): The authoritative architectural blueprint.
  - [ImplementationPlan.md](./ImplementationPlan.md): The phased execution roadmap.
- **Mandate:** All changes must align with these principles and implementation phases.

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
