# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## New machine setup

**macOS / Linux / Raspberry Pi:**
```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply git@github.com:buzzsurfr/dotfiles.git
```

**Windows (PowerShell):**
```powershell
& ([scriptblock]::Create((irm 'https://get.chezmoi.io/ps1'))) -- init --apply git@github.com:buzzsurfr/dotfiles.git
```

During first run, chezmoi will prompt for machine-specific values (iTerm2 size, AWS Starship display), then automatically:
1. Apply all dotfiles
2. Install Homebrew (macOS/Linux)
3. Install all packages from `Brewfile` (macOS)
4. Install oh-my-zsh (macOS/Linux/RPi)
5. Install global npm packages: `@n8n/cli`, `ddb-mcp` (macOS)
6. Configure iTerm2 preferences (macOS)
7. Resolve and write secrets from 1Password (requires 1Password CLI authenticated)

### Manual steps (once per machine)

**1Password SSH agent** — in the 1Password app: Settings → Developer → Use the SSH agent. Then import SSH keys as SSH Key items.

**AWS CLI plugin** — wires `aws` to inject credentials from 1Password at runtime:
```sh
op plugin init aws
# Select: AWS Access Key - buzzsurfr (Private)
# Set as global default
```

## Managing dotfiles

```sh
# See what would change
chezmoi diff

# Apply changes from source to home directory
chezmoi apply

# Pull latest from GitHub and apply
chezmoi update

# Add a new file to chezmoi
chezmoi add ~/.some-new-file

# Edit a tracked file (opens in $EDITOR, applies on save)
chezmoi edit ~/.zshrc

# Open the source directory
chezmoi cd
```

## Machine-specific config

On first `chezmoi init`, you are prompted for:

| Prompt | Purpose | Default |
|--------|---------|---------|
| iTerm2 columns | Window width | 220 |
| iTerm2 rows | Window height | 50 |
| Always show AWS in Starship | `force_display` in starship.toml | false |

Answers are stored locally in `~/.config/chezmoi/chezmoi.toml` (never committed). To change a value:
```sh
chezmoi init   # re-prompts for any missing values
# or edit directly:
chezmoi edit-config
```

## What's included

| File | Purpose |
|------|---------|
| `.zshrc` | Shell config, plugins, aliases, functions |
| `.zprofile` | Login shell — Homebrew PATH (macOS only) |
| `.gitconfig` | Git identity and credential helper |
| `.config/starship.toml` | Starship prompt (AWS display is per-machine) |
| `.config/op/plugins.sh` | 1Password CLI plugin aliases (`aws` → `op plugin run`) |
| `.config/op/plugins/aws.json` | 1Password AWS plugin config |
| `.aws/config` | AWS CLI region and output defaults |
| `.aws/credentials.template` | Credentials setup instructions |
| `.ssh/config` | SSH hosts and 1Password agent socket (OS-conditional) |
| `.kube/config` | Kubeconfig — pulled live from 1Password on each apply |
| `Library/Application Support/Claude/claude_desktop_config.json` | Claude Desktop MCP servers — secrets resolved from 1Password (macOS) |
| `.n8n-cli/config.json` | n8n-cli URL and API key — resolved from 1Password |
| `.config/iterm2/com.googlecode.iterm2.plist` | iTerm2 preferences (macOS) |
| `Library/Application Support/Code/User/settings.json` | VS Code settings (macOS) |
| `Brewfile` | All Homebrew packages, casks, and VS Code extensions |

## Secrets

Secrets are resolved at apply time via chezmoi's 1Password integration — no manual sync steps required. Requires `op` CLI to be authenticated when running `chezmoi apply` or `chezmoi update`.

| Secret | 1Password item |
|--------|---------------|
| Trello MCP API key + token | `Private/Trello MCP` |
| GitHub MCP PAT | `Private/GitHub MCP PAT` |
| n8n API key | `Private/n8n-cli API Key` |
| kubeconfig | `Private/kubeconfig` (secure note) |

## Local overrides

Machine-specific or secret config goes in `~/.localrc` — sourced by `.zshrc` if it exists, never tracked.
