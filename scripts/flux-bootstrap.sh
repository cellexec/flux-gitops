#!/usr/bin/env bash

echo ""
echo "ℹ️  Bootstrapping with '--silent'. Make sure the ssh-key is added to your github"
echo ""
echo ""

# Run bootstrap for a Git repository with a private key and password
flux bootstrap git \
  --url=ssh://git@github.com/cellexec/flux-gitops.git \
  --private-key-file=/home/cellexec/.ssh/id_rsa \
  --path=clusters/homelab \
  --silent
