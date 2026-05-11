# 💾 Backup & Disaster Recovery Procedures

This document outlines the configuration and maintenance of the homelab's backup systems. We use **Velero** with the **Restic/Kopia** plugin for file-level backups of Persistent Volumes.

## ☁️ Off-site Tier: Cloudflare R2

We use Cloudflare R2 as our off-site S3-compatible storage due to its 10GB free tier and zero egress (download) fees.

### Setup Instructions (Manual)

1.  **Create Bucket:**
    *   Log in to the [Cloudflare Dashboard](https://dash.cloudflare.com/).
    *   Navigate to **R2 > Overview > Create bucket**.
    *   Name the bucket (e.g., `jhevans-homelab-backups`).
2.  **Generate API Credentials:**
    *   Go to **R2 > Overview > Manage R2 API Tokens**.
    *   Click **Create API token**.
    *   **Token name:** `homelab-velero`.
    *   **Permissions:** `Object Read & Write`.
    *   **TTL:** `Forever` (or a long duration).
    *   Click **Create Token**.
3.  **Capture Credentials:**
    *   Copy the **Access Key ID**.
    *   Copy the **Secret Access Key**.
    *   Copy the **Jurisdiction-specific endpoint** (S3 API). It will look like `https://<account-id>.r2.cloudflarestorage.com`.

## 🛡️ Secret Management

Credentials for the backup tier are stored in `secrets/velero-credentials.yaml` and encrypted via SOPS using the cluster's Age key.

## 🔄 Recovery Procedures

To verify a backup or recover from a disaster, follow the "Simulated Disaster" steps in `ImplementationPlan.md`.
