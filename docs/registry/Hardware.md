# 🖥️ Hardware Inventory

This document tracks the **present** physical hardware assets of the homelab. For aspirational or planned hardware, see [docs/identity/](../identity/).

## 1. Network Infrastructure
| Device | Model | Role | Details |
| :--- | :--- | :--- | :--- |
| **Primary Router** | TP-Link Deco X50 (Unconfirmed) | Mesh Gateway | Main mesh node. Source: [NAS-DESIGN.md](../identity/NAS-DESIGN.md) |
| **Mesh Nodes** | TP-Link Deco X50 (Unconfirmed) | WiFi Expansion | Source: [NAS-DESIGN.md](../identity/NAS-DESIGN.md) |

## 2. Compute Nodes
| Hostname | Model | Purpose | Primary Specs |
| :--- | :--- | :--- | :--- |
| **control-plane-01** | HP EliteDesk Mini PC | K3s Control Plane | Intel x86_64, NVMe Storage. Source: [README.md](../../nixos/hosts/control-plane-01/README.md) |
| **desktop** | Custom Build | GPU Worker / AI | RTX 3060 Ti. Source: [ProjectPlan.md](../identity/ProjectPlan.md) |

## 3. Utility & IoT
| Hostname | Model | Role | Details |
| :--- | :--- | :--- | :--- |
| **EmonHP** | Raspberry Pi | Heat Pump Monitor | Source: [IPAM.md](./IPAM.md) |
| **dns-pi** | Raspberry Pi (Unconfirmed) | Secondary DNS | Source: [ProjectPlan.md](../identity/ProjectPlan.md) |
