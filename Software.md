Based on our deep dive, here is the categorized list of the software stack for your 2026 Home Lab. This list spans from the base operating system up to the autonomous AI agents.

## 1. The Core Infrastructure (OS & Orchestration)
* **NixOS:** The backbone. A declarative, immutable Linux distribution that ensures your entire system state is reproducible via code.
* **K3s:** A lightweight, CNCF-certified Kubernetes distribution. It’s the "brain" of your cluster, optimized for everything from Mini PCs to high-end desktops.
* **NVIDIA Container Toolkit:** Bridges the gap between your hardware (RTX 3060 Ti) and Kubernetes, allowing pods to access GPU resources.
* **K3d:** The "Weekend Warrior" tool. Runs K3s nodes inside Docker containers on your Windows machine for risk-free testing.

## 2. The GitOps & Management Layer
* **Forgejo:** Your internal "GitHub." A 100% community-owned, lightweight Git forge to host your private IaC repositories.
* **FluxCD or ArgoCD:** The GitOps operator. Flux is the "silent worker" (pure pull-based), while ArgoCD provides a powerful web UI to visualize your cluster’s health.
* **External-DNS:** The automation glue. It watches your Kubernetes services and automatically creates DNS records in your sinkhole.
* **Renovate Bot:** Automatically scans your Git repos and opens Pull Requests to update your Helm charts and Docker image versions.

## 3. Networking & Security
* **WireGuard:** The modern VPN standard. Provides high-speed, encrypted access to your lab from your Android phone or laptop.
* **Pi-hole or AdGuard Home:** The DNS Sinkhole. Blocks ads/trackers network-wide and serves as the local DNS registry for your `.lab.local` domains.
* **Vaultwarden:** A lightweight, self-hosted implementation of the Bitwarden API for secure, synchronized password management.
* **Authentik or Authelia:** Provides Single Sign-On (SSO) and Dashboarding, so you can log into all your services with one set of credentials.

## 4. AI & Development
* **Ollama:** The easiest way to run local LLMs (Llama 3, Mistral, etc.) with a simple API.
* **Open WebUI:** A feature-rich, ChatGPT-like interface that connects to your local Ollama instance.
* **Gemini CLI:** Your "Agentic" coding assistant. In your setup, this will run in a NixOS Docker sandbox with the "leeway" to help you build and debug your lab.
* **OpenClaw / Hermes Agent:** Autonomous AI agents that live in your messaging apps (Telegram/Discord) to monitor your lab and execute complex tasks on your behalf.

## 5. Monitoring & Observability
* **Prometheus:** The metrics engine. It "scrapes" data from every part of your cluster to track CPU, RAM, and network health.
* **Grafana:** The visualization layer. Provides beautiful dashboards to see exactly what your Mini PC and Desktop are doing.
* **Uptime Kuma:** A simple status page that pings your services and notifies you if something (like your VPN) goes down.
* **Loki / Alloy:** Handles log aggregation, so you can search through all your pod logs in one place instead of using the terminal.

## 6. Home Automation & Media
* **Home Assistant:** The "Brain" of your house. It integrates your smart devices and can even "wake" your desktop via Wake-on-LAN when needed.
* **Jellyfin:** The 100% open-source media server. Streams your movies and music to any device without paywalls or tracking.
* **Immich:** A high-performance self-hosted backup solution for your photos and videos (the Google Photos killer).
* **Frigate NVR:** AI-powered CCTV software. It uses your GPU to detect people and objects in real-time, sending smart alerts to your phone.

## 7. Autonomous Operations Center (AOC) Components (TBC)
The proposed software stack for the agentic layer is detailed in the machine-generated **[AROC.md](./AROC.md) (TBC)** document.

---

### 💡 Software Philosophy Summary
* **Fully OSS:** Forgejo, Home Assistant, Jellyfin, FluxCD, Vaultwarden, NixOS, WireGuard.
* **Open-Core / Mixed:** ArgoCD, Authentik, Frigate (Plus features).
* **Open-Weights (AI):** The models run by Ollama (Llama, etc.) are "Open Weights," meaning the software is open but the model's "training secret sauce" is proprietary.

This list gives you a professional-grade stack that is entirely manageable through the GitOps and NixOS principles we've established. Which one are you most excited to see "live" in your K3d sandbox this weekend?
