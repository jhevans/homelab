# 🤖 Autonomous Research & Operations Center (AROC)

> [!CAUTION]
> **STATUS: TBC (To Be Confirmed)**
> This is a **machine-generated blueprint** intended for spurring ideas and brainstorming. It is **NOT** a concrete implementation plan and requires manual review and validation before any action is taken.

This document serves as the high-level vision for the agentic layer of the home lab, moving from foundational infrastructure to high-level "LifeOps" utility.

---

## 🏗️ Phase 1: The Intelligent Foundation
*The core infrastructure required to support autonomous agents.*

| Project | Description | Primary Tech |
| :--- | :--- | :--- |
| **Inference Proxy** | A centralized gateway that routes LLM requests to GPU, CPU, or Cloud based on priority/load. | LiteLLM, Ollama, vLLM |
| **Vector Memory Hub** | A unified `pgvector` extension in your Postgres DB to store embeddings for all other agents. | Postgres, pgvector |
| **Lab Event Bus** | A message broker that lets agents "talk" to each other. | NATS, RabbitMQ |
| **In-Cluster Registry** | Private storage for your agent-built container images and helm charts. | Harbor, Dragon |

---

## 🤖 Phase 2: The Agentic Workforce
*Autonomous entities that perform specific, high-value tasks.*

| Agent | Responsibility | Output |
| :--- | :--- | :--- |
| **Dev Agent** | Runs a full autonomous development environment to write/test code. | PRs to GitOps Repo |
| **GitOps Auditor** | Scans deployments for health, security vulnerabilities, or misconfigurations. | K8s Health Reports |
| **Scout Agent** | Searches the web for tools/techniques tailored to your specific lab interests. | Entries in Vector DB |
| **Knowledge Agent** | Manages your Obsidian Vault; linking notes, fixing formatting, and adding context. | Enhanced Obsidian Vault |
| **Red Team Driller** | Safe, automated chaos engineering and vulnerability exploitation in sandboxes. | Security Hardening PRs |
| **Hardware Whisperer** | Synthesizes noisy system logs (Proxmox/Fans/UPS) into "Daily Standups." | Human-readable Logs |

---

## 🛠️ Phase 3: Daily Utility & "LifeOps"
*Projects that provide tangible, everyday value to your personal life.*

| Project | Description | Daily Value |
| :--- | :--- | :--- |
| **Signal-to-Noise Curator** | Summarizes 100+ RSS/News sources into a 3-sentence morning briefing on your phone. | Saves ~30 mins of scrolling |
| **Financial Sovereign** | Local-first expense tracking and "Subscription Bloat" detection. | Privacy-safe Budgeting |
| **Private Memex** | OCR-indexed personal documents (PDFs, mail, receipts) searchable via LLM. | Instant "Paperless" Search |
| **Contextual Onboarding** | An interactive guide you can ask: *"How do I deploy a new app in this lab?"* | Zero "How-to" Friction |
| **Energy FinOps** | Monitors power draw and scales down K8s replicas at night to save electricity. | Lower Power Bills |

---

## 🗺️ Master Integration Workflow
1.  **Ingestion:** **Scout Agent** finds a tool and saves a summary to **Postgres**.
2.  **Synthesis:** **Knowledge Agent** sees the new entry, links it to existing notes in **Obsidian**, and alerts you.
3.  **Execution:** You tell the **Dev Agent** to "Try it out."
4.  **Deployment:** **Dev Agent** writes the YAML; **GitOps Auditor** scans it; it deploys to **Kubernetes**.
5.  **Documentation:** The **Onboarding Agent** automatically updates your "Live Manual" with the new service details.

---

## 💡 Implementation Strategy
* **Infrastructure First:** Set up **Postgres + pgvector** and **Ollama/LiteLLM** before building the agents.
* **Decoupled Intelligence:** Use small models for the Vector/Embedding layer and larger models for the Reasoning/Dev layer.
* **The "Human in the Loop":** Ensure all Agent actions require a `git commit` or an Obsidian "Approval" tag before they change your production cluster.
