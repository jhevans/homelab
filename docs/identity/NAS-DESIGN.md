# 🗄️ Stateful Storage & Networking Strategy (NAS)

> [!NOTE]
> **Status:** Conceptual Design / Aspirational Architecture.
> This document outlines the proposed strategy for decoupling Compute and State within the homelab.

## 1. Vision: Decoupling Compute & State
The current reliance on **Local Path Provisioning** (storing data on individual node SSDs) creates a "Silo Effect" that hinders maintenance and disaster recovery. The goal is to transition to a centralized, Git-managed, NixOS-based NAS to achieve professional-grade durability.

### Core Benefits
*   **Hardware Independence:** Decouples data from specific node hardware.
*   **Zero-Friction Maintenance:** Allows nodes to be wiped or replaced without complex data migrations.
*   **Redundancy:** Leverages multi-disk ZFS arrays for self-healing storage.

## 2. Proposed Hardware: The Storage Node
To act as the cluster's "Source of Truth," a dedicated storage node is required.

*   **Reference Chassis:** TerraMaster F4-424 Pro (or equivalent x86-64 Open Hardware).
    *   *Rationale:* Standard BIOS allows for replacing proprietary OEM software with NixOS, ensuring the storage configuration is declarative.
*   **Specs:** 8-core CPU / 32GB RAM (optimized for ZFS caching).

### Drive Hierarchy (Hybrid Tiering)
| Tier | Role | Type | Capacity |
| :--- | :--- | :--- | :--- |
| **Tier 1** | Boot / OS | NVMe SSD | 250GB |
| **Tier 2** | Metadata / Hot Cache | NVMe SSD | 500GB+ |
| **Tier 3** | Capacity / Mass Storage | 2x CMR HDD (Mirror) | 8TB+ |

## 3. Storage Area Network (SAN) Strategy
To avoid I/O bottlenecks and interference with primary home internet (Deco X50 mesh, see [Hardware.md](../registry/Hardware.md)), a dedicated high-speed backplane is recommended.

*   **Speed:** 2.5GbE minimum. 1Gbps is likely to cause significant I/O Wait on SSD-backed workloads.
*   **Isolation:** A dedicated (logical or physical) side-car network for storage traffic.
*   **Switching:** An unmanaged 2.5GbE switch connecting the NAS, the Mini PC, and the Desktop worker.

## 4. Implementation Workflow
The proposed deployment pattern for integrating the NAS into the existing cluster:

1.  **NixOS Bootstrap:** Provision the NAS via Nix Flakes, defining the ZFS pool and NFSv4 exports.
2.  **K8s Integration:** Deploy an NFS CSI driver (e.g., `nfs-subdir-external-provisioner`) to the K3s cluster.
3.  **Stateful Migration:** Transition core services (e.g., Forgejo) from `local-path` to the new `nfs-client` StorageClass.
4.  **Validation:** Verify that workloads successfully re-mount their storage after a node failure or scheduled maintenance.

## ⚠️ Critical Constraints
*   **CMR Only:** Avoid SMR (Shingled Magnetic Recording) drives to prevent ZFS pool failures during resilvering.
*   **Network Capacity:** 2.5GbE is considered a prerequisite for this stateful model to ensure performance parity with local SSDs.
*   **Validation:** All hardware choices and software versions should be re-validated against the current market at the time of procurement.
