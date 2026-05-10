# ⚠️ Project Observations & Risks

This document tracks identified technical states and potential vulnerabilities in the homelab.

---

## Technical Observations

### State Management: Per-App Databases
*   **Current State:** Applications like Paperless-ngx are deployed using subcharts that include their own Postgres and Redis instances.
*   **Context:** This results in multiple isolated database instances across the cluster.

### Authentication: Per-App Auth
*   **Current State:** Services are exposed via Traefik Ingress but do not currently utilize the centralized Authelia instance for ForwardAuth.
*   **Context:** Authentication is handled individually by each application (or not at all if the app lacks built-in auth).

### AI Workload: CPU Inference
*   **Current State:** Ollama is running on the `control-plane-01` node using CPU-based inference.
*   **Context:** LLM workloads are sharing CPU cycles with core infrastructure services.

### Data Durability: Backup Status
*   **Current State:** A disaster recovery plan using Velero is documented but has not yet been implemented or verified on the physical hardware.
*   **Context:** Persistent volumes currently rely on the local storage of the single-node cluster.

### TLS Status: Internal Plaintext
*   **Current State:** Internal services are served over HTTP (`http://*.lab.local`).
*   **Context:** Traffic between users and the Traefik ingress is unencrypted, meaning credentials and data are sent in plaintext over the local network.

### Credential Strength: Simplistic Passwords
*   **Current State:** Several services (e.g., Grafana, Paperless-ngx) may still be using default or simplistic passwords.
*   **Context:** Weak credentials increase the likelihood of successful unauthorized access if an entry point is found.

### Dependency Management: Version Staleness
*   **Current State:** Helm charts and container images are pinned to specific versions in the manifests.
*   **Context:** These versions have not been systematically audited for security updates or bug fixes since initial deployment.

### Hardware: Single Point of Failure (SPOF)
*   **Current State:** All core infrastructure (DNS, Auth, Git, Control Plane) resides on a single physical node (`control-plane-01`).
*   **Context:** A hardware failure on this specific machine results in total service unavailability. 
*   **Addressing Plan:** See [NAS-DESIGN.md](./NAS-DESIGN.md) for the strategy regarding distributed storage and high-speed networking to mitigate this.

### Resource Management: Lack of Limits
*   **Current State:** Kubernetes manifests generally lack defined CPU and Memory `resources` (limits/requests).
*   **Context:** A single application experiencing a memory leak or CPU spike could potentially starve other critical services or destabilize the host node.

### Host Maintenance: Manual Patching
*   **Current State:** NixOS system updates for `control-plane-01` are performed manually via `nixos-rebuild`.
*   **Context:** There is no automated mechanism to ensure the host operating system receives timely security patches for its kernel and system packages.

### Network Policy: Unsecured Local Network Trust
*   **Current State:** The lab infrastructure operates on a "Trusted Internal Network" model.
*   **Context:** There are no internal firewalls or mandatory authentication barriers (SSO) between the local network and individual services. If a single device on the home network (e.g., an IoT device or guest laptop) is compromised, an attacker can directly access the login interfaces or APIs of all lab services, facilitating lateral movement (pivoting).
