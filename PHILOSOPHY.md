# 🌌 Project Philosophy & Ethos

This document captures the current thinking and guiding principles for the homelab. These are not hard, unbreakable rules, but rather a **living ethos** that will evolve as we discover what works. Unless a principle is explicitly marked as "unbreakable" in `GEMINI.md`, treat these as advice and current best knowledge.

---

## 🏗️ Stability as the Foundation
The primary threat to this project is "friction"—the time and energy lost to constant debugging and instability. 
- **The Goal:** Automate the "boring" stuff first. Focus early agent efforts on reliability and stability.
- **The Payoff:** A rock-solid foundation allows for much faster innovation later.

## 🏰 Sovereignty & Resilience
We aim for almost complete sovereignty, keeping the core of the system independent of external clouds.
- **Local-First:** Core services (DNS, Auth, Git) should ideally run within our walls.
- **The Backup Caveat:** Off-site cloud backups are essential for disaster recovery. We prioritize being "covered" over being "purist."

## 🧑‍💻 Human-in-the-Loop Transparency
The goal is to know the system "inside out." Even as we introduce autonomous agents, the human remains the final arbiter.
- **Transparency:** Agents should be prepared to explain their reasoning and process.
- **Review:** All significant changes should be presented via Pull Requests to ensure visibility and shared understanding.

## ⚡ Energy-Aware Innovation
We want to optimize for the performance-to-cost ratio by syncing our "heavy" workloads with the environment.
- **Free Energy:** Maximize resource usage when electricity is effectively free (solar surplus, Octopus savings).
- **On-Demand Power:** Outside of those windows, we prioritize efficiency but keep the system capable of scaling up instantly when needed.

## 🛡️ Evolving Security Posture
Security isn't a "solved" problem but a continuous practice.
- **Dedicated Focus:** We treat security hardening as a recurring backlog item, not a one-time setup.
- **Adaptability:** As the lab grows, we refine our posture to meet new threats and complexities.
