#!/usr/bin/env bash
set -e

if ! command -v op &>/dev/null; then
  echo "secrets: 1Password CLI not found, skipping"
  exit 0
fi

if ! op whoami &>/dev/null 2>&1; then
  echo "secrets: not authenticated with 1Password — unlock the 1Password app, then re-run ~/.init/secrets.sh"
  exit 0
fi

echo "==> Pulling kubeconfig from 1Password..."
mkdir -p "$HOME/.kube"
op read "op://Private/kubeconfig/notesPlain" > "$HOME/.kube/config"
chmod 600 "$HOME/.kube/config"
echo "    kubeconfig written to ~/.kube/config"
