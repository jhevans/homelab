# 🚀 2026 Home Lab & Private Cloud: Architectural Blueprint

## 1. Concept and Target State
The objective is to move away from fragmented, manually managed "server" setups toward a **unified, declarative Private Cloud**. This lab serves as a professional-grade development environment, a privacy-focused service host, and an AI-augmented "Personal Intelligence Hub."

### The Infrastructure Tiers
* **Core (Always-On):** A high-efficiency **x86 Mini PC** acting as the Kubernetes Control Plane and primary Service Host.
* **Heavy (On-Demand):** A **Windows/NixOS Desktop** (RTX 3060 Ti) acting as a high-compute worker node for LLMs and GPU-accelerated tasks.
* **Utility (Out-of-Band):** **Raspberry Pis** acting as secondary DNS (Pi-hole) and emergency management "jumpboxes."

### Target End-User Experience
* **Secure Remote Access:** Accessing `vault.lab.local` or `llm.lab.local` from an Android phone anywhere in the world via a transparent WireGuard VPN.
* **Agentic Development:** A Gemini-powered CLI assistant with "leeway" to modify code and deploy to the cluster within an isolated NixOS Docker sandbox.

---

## 2. Principles and Design Philosophy
* **GitOps as the Law:** Git is the "Single Source of Truth." If a change isn't in Git, it doesn't exist.
* **Declarative Infrastructure:** Use **NixOS** for the OS layer and **Kubernetes (K3s)** for the application layer to ensure byte-for-byte repeatability.
* **Split-Horizon DNS:** Services should be reachable via the same friendly hostnames whether the user is on the local LAN or the VPN, eliminating hardcoded IPs.
* **Atomic Isolation:** Critical services (DNS, VPN) are separated from experimental ones (AI Agents) to ensure household internet stability.
* **Open Source First:** Priority is given to community-owned, privacy-respecting FOSS (Forgejo, Jellyfin, Home Assistant).

---

## 3. Roadmap & Resources
The execution of this blueprint is divided into specialized documents:

*   **[ImplementationPlan.md](./ImplementationPlan.md):** The phased, iterative roadmap for building the lab.
*   **[Software.md](./Software.md):** The definitive list of the software stack and technology choices.

---

## 4. Appendices and Technical Data

### DNS Resolution Flow
1.  **Request:** User types `forgejo.lab.local`.
2.  **Lookup:** Device asks **Pi-hole** (connected via VPN/LAN).
3.  **Discovery:** Pi-hole returns the Mini PC IP (provided by **External-DNS**).
4.  **Routing:** **Ingress-Nginx** receives the request and routes it to the Forgejo Pod based on the `Host` header.

### The "Gemini Sandbox" Configuration
* **Environment:** Docker Container running a Nix-enabled Linux.
* **Permission:** Volume-mount only specific project directories.
* **Network:** Connect container to the WireGuard network to allow the AI to "see" cluster services for debugging.

---

### Other Information
* **Backup Strategy:** Mirror your internal Forgejo repo to GitHub automatically. Keep a physical printout of your **WireGuard Private Key** and **NixOS Disk Encryption** passwords in a safe place.
* **Expansion:** As the lab grows, the Mini PC can be upgraded with more RAM (32GB+), and the Raspberry Pis can be utilized as high-availability "witness" nodes for the K3s database.

**This document is a living artifact. Update your Git repo first, and the lab will follow.**
