# 📦 Software Inventory & Stack

This document tracks the definitive software stack for the homelab. All software choices must align with the [PHILOSOPHY.md](../identity/PHILOSOPHY.md).

## 1. Core Infrastructure
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **OS** | [NixOS](https://nixos.org/) | Declarative, immutable host configuration. |
| **Orchestration** | [K3s](https://k3s.io/) | Lightweight Kubernetes distribution. |
| **GPU Support** | NVIDIA Container Toolkit | GPU acceleration for pods (Desktop node). |
| **Testing** | [K3d](https://k3d.io/) | Local K8s clusters in Docker for sandbox testing. |

## 2. GitOps & Management
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Git Forge** | [Forgejo](https://forgejo.org/) | Internal Git hosting (Self-sovereign). |
| **GitOps Operator** | [FluxCD](https://fluxcd.io/) | Automated synchronization of K8s manifests. |
| **DNS Automation** | External-DNS | Automatic DNS record creation in AdGuard Home. |
| **Automation** | Renovate Bot | Automated dependency updates for Helm/Images. |

## 3. Data Protection
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Backup** | [Velero](https://velero.io/) | Cluster-wide backup and disaster recovery. |
| **Uploader** | [Kopia](https://kopia.io/) | File-level backups of Persistent Volumes. |
| **Off-site** | [Cloudflare R2](https://www.cloudflare.com/lp/pg-r2/) | S3-compatible off-site storage (Egress-free). |

## 4. Networking & Security
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **VPN** | [WireGuard](https://www.wireguard.com/) | Secure remote access. |
| **DNS Sinkhole** | [AdGuard Home](https://adguard.com/en/adguard-home/overview.html) | Network-wide ad blocking & local DNS. |
| **Secrets** | [SOPS](https://github.com/getsops/sops) + [Age](https://github.com/FiloSottile/age) | Encrypted secrets management in Git. |
| **Auth/SSO** | Authentik / Authelia | Unified authentication and SSO dashboard. |
| **Vault** | Vaultwarden | Lightweight Bitwarden-compatible password manager. |

## 5. Observability
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Metrics** | Prometheus | Cluster-wide metrics scraping. |
| **Dashboards** | Grafana | Visualization and alerting. |
| **Visualizer** | [kube-aura](https://github.com/jhevans/kube-aura) | Real-time cluster visualization. |
| **Status Page** | Uptime Kuma | Service availability monitoring. |
| **Logging** | Loki + Alloy | Log aggregation and search. |

## 6. Productivity & AI
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **AI Inference** | [Ollama](https://ollama.com/) | Local LLM hosting. |
| **AI Interface** | Open WebUI | ChatGPT-like UI for local models. |
| **Documents** | [Paperless-ngx](https://docs.paperless-ngx.com/) | OCR-indexed document management. |

## 7. Home & Media
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Home Automation** | [Home Assistant](https://www.home-assistant.io/) | Smart home hub. |
| **Media Server** | [Jellyfin](https://jellyfin.org/) | Privacy-focused media streaming. |
| **Photos** | [Immich](https://immich.app/) | High-performance self-hosted photo backup. |
| **CCTV** | [Frigate NVR](https://frigate.video/) | AI-powered local video recorder. |

---

## 💡 Philosophy Summary
*   **Local-First:** All core data stays on-premises.
*   **Open Source:** 100% FOSS wherever possible.
*   **Declarative:** Managed via NixOS and GitOps.
