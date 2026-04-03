#!/bin/bash

# 🚀 2026 Home Lab: Sandbox Bootstrap Script
# This script creates a NEW k3d cluster and bootstraps Flux.

set -e

# --- Defaults ---
K3S_IMAGE="rancher/k3s:v1.34.1-k3s1"
AGE_KEY_FILE="${HOME}/.age/homelab.age"

# --- Usage ---
usage() {
    echo "Usage: $0 --name <CLUSTER_NAME> --token <GITHUB_TOKEN> --owner <GITHUB_OWNER> --repo <GITHUB_REPO> [--age-key <PATH>]"
    echo ""
    echo "Arguments:"
    echo "  --name     Name for the new k3d cluster"
    echo "  --token    Your GitHub Personal Access Token (PAT)"
    echo "  --owner    GitHub Username (e.g., jhevans)"
    echo "  --repo     GitHub Repository Name (e.g., homelab)"
    echo "  --age-key  Optional: Path to your Age private key (default: ${AGE_KEY_FILE})"
    exit 1
}

# --- Parse Arguments ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --name) CLUSTER_NAME="$2"; shift ;;
        --token) GITHUB_TOKEN="$2"; shift ;;
        --owner) GITHUB_OWNER="$2"; shift ;;
        --repo) GITHUB_REPO="$2"; shift ;;
        --age-key) AGE_KEY_FILE="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

if [[ -z "$CLUSTER_NAME" || -z "$GITHUB_TOKEN" || -z "$GITHUB_OWNER" || -z "$GITHUB_REPO" ]]; then
    usage
fi

KUBECONFIG_FILE="${HOME}/.kube/config-${CLUSTER_NAME}"

# --- 1. Check if cluster exists ---
if sudo k3d cluster list | grep -q "$CLUSTER_NAME"; then
    echo "❌ Error: Cluster '$CLUSTER_NAME' already exists. Choose a different name."
    exit 1
fi

# --- 2. Create k3d cluster ---
echo "🏗️ Creating k3d cluster: $CLUSTER_NAME..."
sudo k3d cluster create "$CLUSTER_NAME" \
    --image "$K3S_IMAGE" \
    --port "8080:80@loadbalancer" \
    --port "8443:443@loadbalancer" \
    --wait

# --- 3. Export Kubeconfig ---
echo "🔑 Exporting kubeconfig to $KUBECONFIG_FILE..."
sudo k3d kubeconfig get "$CLUSTER_NAME" > "$KUBECONFIG_FILE"
export KUBECONFIG="$KUBECONFIG_FILE"

# --- 4. Prepare Secret Management (SOPS + Age) ---
echo "🔐 Setting up sops-age secret..."
if [[ ! -f "$AGE_KEY_FILE" ]]; then
    echo "❌ Error: Age key file not found at $AGE_KEY_FILE"
    exit 1
fi

kubectl create namespace flux-system --dry-run=client -o yaml | kubectl apply -f -
cat "$AGE_KEY_FILE" | kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file=age.agekey=/dev/stdin \
    --dry-run=client -o yaml | kubectl apply -f -

# --- 5. Bootstrap Flux ---
echo "🌊 Bootstrapping Flux..."
export GITHUB_TOKEN="$GITHUB_TOKEN"
export PATH=$PATH:$HOME/.local/bin
flux bootstrap github \
    --owner="$GITHUB_OWNER" \
    --repository="$GITHUB_REPO" \
    --branch=main \
    --path=./kubernetes/flux \
    --secret-name=flux-system \
    --personal \
    --interval=1m

echo "✅ Cluster '$CLUSTER_NAME' creation complete!"
echo "👉 To use your cluster, run: export KUBECONFIG=$KUBECONFIG_FILE"
