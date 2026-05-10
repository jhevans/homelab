# Homelab Documentation Architecture

This reference defines the purpose and "Source of Truth" (SoT) for each documentation file in the homelab project.

## Core Mandates
- **GEMINI.md**: Foundational mandates and project-specific instructions for the agent. **Primary SoT for workflows.**
- **ProjectPlan.md**: The authoritative architectural blueprint. High-level vision. **Primary SoT for architecture.**
- **ImplementationPlan.md**: The phased execution roadmap. **Primary SoT for task status.**
- **PHILOSOPHY.md**: The project's guiding ethos and living principles. **Primary SoT for values.**

## Technical Data
- **Software.md**: The definitive list of the software stack.
- **IPAM.md**: Static IP assignments and network topology.
- **GOTCHAS.md**: Architectural decisions, common pitfalls, and "non-obvious" behaviors.
- **AROC.md**: Vision for the agentic layer (TBC).

## Maintenance Rules
1. **No Duplication**: If information exists in an "Architecture" file (e.g. ProjectPlan), do not repeat the full detail in a "Task" file (e.g. ImplementationPlan). Link instead.
2. **Status Accuracy**: `ImplementationPlan.md` must reflect the verified state of the lab. The presence of a manifest in the filesystem is not proof of completion; a service must be verified as working as designed before being marked `[x]`.
3. **Implicit Sync**: When a decision is made in `GOTCHAS.md` (e.g. "One File Per Secret"), ensure it is also mentioned as a constraint in `GEMINI.md` if it affects agent behavior.
4. **Dead Link Prevention**: All markdown links `[text](./path/to/file.md)` must be verified after any file move or rename.
