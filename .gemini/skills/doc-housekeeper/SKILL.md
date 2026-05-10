---
name: doc-housekeeper
description: Documentation consolidation and maintenance for the homelab project. Use when cleaning up docs, syncing implementation status with the repo, auditing for redundancies, or validating cross-references across ProjectPlan, ImplementationPlan, and GEMINI.md.
---

# Doc Housekeeper

## Overview
This skill ensures the homelab documentation remains a "Single Source of Truth" (SoT). It handles the overhead of keeping high-level plans in sync with low-level execution.

## Core Tasks

### 1. Status Synchronization & Verification
Sync `ImplementationPlan.md` with the actual state of the repository and the cluster.
- **Trigger**: "Sync implementation status" or "Update the plan."
- **Action**: 
    1. Scan the filesystem for apps, configs, and secrets mentioned in the plan.
    2. If a manifest exists but the task is NOT marked `[x]`, flag it as **"Awaiting Verification."** Do NOT mark it complete automatically.
    3. Verification Rule: A task is only marked `[x]` after empirical verification (e.g., checking pod status, logs, or UI availability) confirms it is working as designed.
    4. If a task is marked `[x]` but its manifest/code is missing from the repo, flag it as **"Stale/Orphaned."**

### 2. Redundancy & Divergence Audit
Identify overlapping information across the core docs.
- **Trigger**: "Audit documentation" or "Check for redundancies."
- **Action**:
    1. Compare `ProjectPlan.md`, `Software.md`, and `ImplementationPlan.md`.
    2. Flag sections that repeat the same details instead of linking.
    3. Ensure `GEMINI.md` ethos matches `PHILOSOPHY.md`.

### 3. Cross-Reference Validation
Ensure all documentation links are valid.
- **Trigger**: "Validate doc links" or "Fix broken references."
- **Action**: 
    1. Use `grep` to find all internal markdown links.
    2. Verify the target files exist.

### 4. Decision Propagation
Ensure architectural decisions in `GOTCHAS.md` are propagated to relevant instructions.
- **Trigger**: "Propagate decisions" or "Update constraints."
- **Action**:
    1. Read recent entries in `GOTCHAS.md`.
    2. Update `./GEMINI.md` or subdirectory `GEMINI.md` files with new constraints (e.g., "One file per secret").

## Guidelines
See [homelab-docs.md](references/homelab-docs.md) for the authoritative mapping of file purposes and SoT rules.
