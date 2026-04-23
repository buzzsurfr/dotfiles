# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
plugins=(git 1password aws kubectl bgnotify)
source $ZSH/oh-my-zsh.sh

# environment
export AWS_PROFILE=personal
export LOCALSTACK_HOST=awslocal
export HOMEBREW_NO_ENV_HINTS=1
export PATH="$PATH:${HOME}/.krew/bin:${HOME}/go/bin:${HOME}/.local/bin"

# dotfiles
alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# machine-specific overrides (not tracked)
[[ -f "$HOME/.localrc" ]] && source "$HOME/.localrc"

# functions
merge_json() {
  local target="$1"
  local patch="${2:-/dev/stdin}"
  jq -s '.[0] * .[1]' "$target" "$patch" > /tmp/_merged.json && mv /tmp/_merged.json "$target"
  echo "Merged into $target"
}

sshfix() {
  local host="${1:?Usage: sshfix <hostname>}"
  local known_hosts="$HOME/.ssh/known_hosts"
  local line_num
  line_num=$(ssh -o StrictHostKeyChecking=yes "$host" 2>&1 | \
    grep -oE 'known_hosts:[0-9]+' | grep -oE '[0-9]+')
  if [[ -n "$line_num" ]]; then
    echo "Removing offending key at line $line_num from known_hosts..."
    sed -i '' "${line_num}d" "$known_hosts"
  else
    echo "No offending key found"
  fi
}

# prompt
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
eval "$(starship init zsh)"
