#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"

function config {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

echo "==> Pulling latest dotfiles..."
config pull

echo "==> Syncing Homebrew packages..."
brew bundle --file="$HOME/Brewfile"

echo "==> Updating oh-my-zsh..."
"$HOME/.oh-my-zsh/tools/upgrade.sh" 2>/dev/null || true

echo ""
echo "Done! Restart your terminal if shell config changed."
