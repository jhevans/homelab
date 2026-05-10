# Homelab Documentation Architecture

This reference defines the purpose and "Source of Truth" (SoT) for each documentation file in the homelab project.

## Core Hierarchy

### 1. Identity (`docs/identity/`)
*The "Soul" of the lab. Strategy and Vision.*
- **`ProjectPlan.md`**: Primary SoT for **Architecture**.
- **`PHILOSOPHY.md`**: Primary SoT for **Values**.
- **`AROC.md`**: Future Vision.

### 2. Registry (`docs/registry/`)
*The "Cold" Data. Specifications and Facts.*
- **`Software.md`**: Primary SoT for **Software Stack**.
- **`IPAM.md`**: Primary SoT for **Network Topology**.

### 3. Workflow (`docs/workflow/`)
*The "How". Execution and Status.*
- **`ImplementationPlan.md`**: Primary SoT for **Task Status**.
- **`bootstrap-guide.md` / `ssh-management.md`**: Standard Operating Procedures.

### 4. Memory (`docs/memory/`)
*The "Experience". Lessons and Decisions.*
- **`GOTCHAS.md`**: Primary SoT for **Architectural Decision Records (ADR)** and Pitfalls.

## Maintenance Rules
1. **No Duplication**: If information exists in an "Identity" file, do not repeat detail in a "Workflow" file. Link instead.
2. **Status Accuracy**: `ImplementationPlan.md` must reflect the verified state of the lab.
3. **Implicit Sync**: Decisions in `memory/` must be propagated to `GEMINI.md` as constraints if they affect agent behavior.
4. **Dead Link Prevention**: All markdown links must be verified after any file move.
