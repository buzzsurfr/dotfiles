#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"

function config {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

echo "==> Pulling latest dotfiles..."
# lift skip-worktree so pull can update tracked defaults
config update-index --no-skip-worktree .config/iterm2/com.googlecode.iterm2.plist 2>/dev/null || true
config update-index --no-skip-worktree .config/starship.toml 2>/dev/null || true
config pull

echo "==> Syncing Homebrew packages..."
brew bundle --file="$HOME/Brewfile"

echo "==> Updating oh-my-zsh..."
"$HOME/.oh-my-zsh/tools/upgrade.sh" 2>/dev/null || true

# --- re-apply machine-specific settings ---
local_config="$HOME/.init/machine.local.sh"
if [[ -f "$local_config" ]]; then
  source "$local_config"
  if [[ -n "$ITERM_COLS" && -n "$ITERM_ROWS" ]]; then
    plist="$HOME/.config/iterm2/com.googlecode.iterm2.plist"
    /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Columns $ITERM_COLS" "$plist"
    /usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Rows $ITERM_ROWS" "$plist"
    config update-index --skip-worktree .config/iterm2/com.googlecode.iterm2.plist
  fi
  if [[ "$STARSHIP_AWS_FORCE_DISPLAY" == "true" ]]; then
    sed -i '' 's/^force_display = .*/force_display = true/' "$HOME/.config/starship.toml"
    config update-index --skip-worktree .config/starship.toml
  fi
fi

# --- secrets ---
"$HOME/.init/secrets.sh"

echo ""
echo "Done! Restart your terminal if shell config changed."
