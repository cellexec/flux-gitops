#!/usr/bin/env bash

set -euo pipefail

# create secret with gpg private key
kubectl create secret generic sops-gpg \
  --from-file=sops.asc=gpg.asc \
  -n flux-system \
  --dry-run=client \
  -o yaml \
  | kubectl apply -f -

