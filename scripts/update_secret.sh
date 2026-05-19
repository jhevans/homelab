#!/usr/bin/env bash

# Hermes Secret Updater
# Allows updating SOPS-encrypted Kubernetes secrets via CLI.
# Usage: ./scripts/update_secret.sh GITHUB_TOKEN=your_token_here

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 KEY=VALUE"
    echo "Example: $0 GITHUB_TOKEN=ghp_xxxxxxxxxxxx"
    exit 1
fi

# Parse input
KEY=$(echo "$1" | cut -d= -f1)
VALUE=$(echo "$1" | cut -d= -f2-)

# Target secret file
SECRET_FILE="kubernetes/apps/ai/hermes/secrets.yaml"

if [ ! -f "$SECRET_FILE" ]; then
    echo "Error: $SECRET_FILE not found. Please run this script from the root of the homelab repository."
    exit 1
fi

# Check if sops is installed
if ! command -v sops &> /dev/null; then
    echo "Error: 'sops' is not installed or not in PATH."
    echo "Please install it: https://github.com/getsops/sops"
    exit 1
fi

echo "Updating $KEY in $SECRET_FILE..."

# Update the secret using sops
# We use the bracket notation for stringData keys
sops --set "[\"stringData\"][\"$KEY\"] \"$VALUE\"" "$SECRET_FILE"

# Stage and commit
git add "$SECRET_FILE"
git commit -m "chore(secrets): update $KEY in hermes-secrets"

echo "--------------------------------------------------"
echo "✅ Successfully updated and committed $KEY."
echo "Syncing with cluster via Flux (if configured)..."
echo "--------------------------------------------------"
