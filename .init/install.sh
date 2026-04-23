#!/usr/bin/env bash
set -e

DOTFILES_REPO="https://github.com/buzzsurfr/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

function config {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# --- dotfiles ---
if [[ -d "$DOTFILES_DIR" ]]; then
  echo "==> Dotfiles already installed, pulling latest..."
  config pull
else
  echo "==> Cloning dotfiles..."
  git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"

  mkdir -p "$HOME/.dotfiles-backup"

  echo "==> Checking out dotfiles..."
  if ! config checkout 2>/dev/null; then
    echo "    Backing up conflicting files to ~/.dotfiles-backup"
    config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | \
      xargs -I{} sh -c 'mkdir -p "$(dirname "$HOME/.dotfiles-backup/{}")" && mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"'
    config checkout
  fi

  config config status.showUntrackedFiles no
  config config push.autoSetupRemote true
fi
echo "    Dotfiles ready."

# --- homebrew ---
echo "==> Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "==> Installing packages from Brewfile..."
brew bundle --file="$HOME/Brewfile"

# --- oh-my-zsh ---
echo "==> Installing oh-my-zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "    oh-my-zsh already installed."
fi

# --- iterm2 ---
echo "==> Configuring iTerm2 preferences..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.config/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
echo "    iTerm2 will load prefs from ~/.config/iterm2"

echo ""
echo "All done! Open a new terminal to get started."
echo "Add machine-specific config to ~/.localrc (not tracked)."
echo ""
echo "To enable 'config push', authenticate with GitHub:"
echo "  gh auth login"
