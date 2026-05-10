# 📏 Engineering & Documentation Standards

This document defines the practical standards for maintaining the homelab repository. These principles ensure the codebase and documentation remains a "Source of Truth" rather than a "Museum of History."

## 🧹 Repository Hygiene & The YAGNI Principle
We adhere to the **YAGNI (You Ain't Gonna Need It)** principle to minimize maintenance burden and cognitive load.

1. **Aggressive Pruning:** Once an iteration in the `ImplementationPlan.md` is fully completed and verified in production, it is deleted. We do not keep "check-marks" for historical reference.
2. **Ephemeral Data:** Prefer to delete data that is no longer needed rather than holding onto it for "just in case" reference. 
3. **The Git Archive:** We rely on Git history as our time machine. If we ever need to retrieve a retired script or an old plan, it is always available in the logs.
4. **Signal-to-Noise Ratio:** By removing completed tasks, we reduce the scope for conflicting information and ensure that anyone (human or agent) entering the repo can immediately identify the current state and next steps.

## 🛠️ Implementation Standards
*   **Surgical Updates:** Changes should be the minimum necessary to achieve the goal.
*   **Documentation-First:** Any change to the system's state or behavior must be reflected in the relevant `docs/` file before the task is considered complete.
*   **Validation:** All Kubernetes manifests must be validated with `flux build` before committing.
*   **Dashboard Sync:** New services must be added to the `homepage` dashboard configuration immediately.
