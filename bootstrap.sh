#!/usr/bin/env bash

set -euo pipefail

# ------------------------
# Load environment variables
# ------------------------
ENV_FILE=".env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ Missing .env file."
  echo "ℹ️  Please copy '.env.example' to '.env' and fill in the required values:"
  echo ""
  echo "    cp .env.example .env"
  echo ""
  exit 1
fi

# Export all variables from .env
export $(grep -v '^#' "$ENV_FILE" | xargs)

# ------------------------
# Validate required variables
# ------------------------
REQUIRED_VARS=("GITHUB_USER" "REPO_NAME" "CLUSTER_NAME" "GITHUB_TOKEN")
for VAR in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!VAR}" ]]; then
    echo "❌ Missing required variable: $VAR"
    echo "👉 Make sure it's defined in your .env file"
    exit 1
  fi
done

# ------------------------
# Show expected GitHub PAT scopes
# ------------------------
echo ""
echo "🔐 Ensure your GitHub PAT has the following scopes:"
echo "   - repo (to include 'Contents', 'Commit statuses')"
echo "   - admin:repo_hook (for 'Webhooks')"
echo ""

# ------------------------
# Install Flux CLI if missing
# ------------------------
if ! command -v flux &> /dev/null; then
  echo "⬇️ Installing Flux CLI..."
  curl -s https://fluxcd.io/install.sh | sudo bash
else
  echo "✅ Flux CLI is already installed"
fi

# ------------------------
# Define variables
# ------------------------
BRANCH="${BRANCH:-main}"
CLUSTER_PATH="clusters/$CLUSTER_NAME"

# ------------------------
# Bootstrap Flux using GitHub PAT
# ------------------------
echo "🚀 Bootstrapping Flux with GitHub PAT..."

flux bootstrap github \
  --owner="$GITHUB_USER" \
  --repository="$REPO_NAME" \
  --branch="$BRANCH" \
  --path="$CLUSTER_PATH" \
  --personal \
  --token-auth \
  --components-extra=image-reflector-controller,image-automation-controller

# ------------------------
# Done
# ------------------------
echo ""
echo "✅ Flux bootstrap complete!"
echo "📁 Cluster state is now managed at '$CLUSTER_PATH' in your GitHub repo."

