#!/usr/bin/env bash

set -e

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
REQUIRED_VARS=("GITHUB_USER" "REPO_NAME" "CLUSTER_NAME")
for VAR in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!VAR}" ]]; then
    echo "❌ Missing required variable: $VAR"
    echo "👉 Make sure it's defined in your .env file"
    exit 1
  fi
done

# Derived values
CLUSTER_PATH="clusters/$CLUSTER_NAME"
GITHUB_SSH_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
BRANCH="${BRANCH:-main}"
KEY_FILE="$HOME/.ssh/flux_rsa"

# ------------------------
# Create RSA SSH Key (if needed)
# ------------------------
echo "📁 Checking for existing SSH RSA key..."
if [[ ! -f "$KEY_FILE" ]]; then
  echo "🔑 Generating new RSA SSH key at $KEY_FILE"
  ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" -N "" -C "flux"
else
  echo "✅ RSA SSH key already exists at $KEY_FILE"
fi

# ------------------------
# Install Flux CLI (if not installed)
# ------------------------
if ! command -v flux &> /dev/null; then
  echo "⬇️ Installing Flux CLI..."
  curl -s https://fluxcd.io/install.sh | sudo bash
else
  echo "✅ Flux CLI already installed"
fi

# ------------------------
# Bootstrap Flux
# ------------------------
echo "🚀 Bootstrapping Flux with GitHub SSH..."

flux bootstrap github \
  --owner="$GITHUB_USER" \
  --repository="$REPO_NAME" \
  --branch="$BRANCH" \
  --path="$CLUSTER_PATH" \
  --private-key-file="$KEY_FILE" \
  --hostname=github.com \
  --ssh-hostname=github.com \
  --personal

# ------------------------
# Done
# ------------------------
echo "🎉 Flux bootstrap completed!"
echo ""
echo "📎 Add this public key to your GitHub repo as a Deploy Key:"
echo ""
cat "$KEY_FILE.pub"
echo ""
echo "🔗 GitHub > $REPO_NAME > Settings > Deploy keys > Add deploy key (✓ Allow write access)"
