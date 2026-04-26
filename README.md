# dotfiles

Personal dotfiles managed with a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles).

## New machine setup

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/buzzsurfr/dotfiles/main/.init/install.sh)
```

This will:
1. Clone the repo as a bare git repo to `~/.dotfiles`
2. Check out config files into `$HOME`
3. Install [Homebrew](https://brew.sh) and all packages in `Brewfile`
4. Install [oh-my-zsh](https://ohmyz.sh)
5. Pull secrets from 1Password (kubeconfig) — requires the 1Password app to be unlocked

Then open a new terminal.

### Manual steps (once per machine)

**1Password SSH agent** — in the 1Password app: Settings → Developer → Use the SSH agent. Then import SSH keys as SSH Key items.

**AWS CLI plugin** — wires `aws` to inject credentials from 1Password at runtime, no credentials file needed:
```sh
op plugin init aws
# Select: AWS Access Key - buzzsurfr (Private)
# Set as global default
```

## Managing dotfiles

Use the `config` alias (already in `.zshrc`) instead of `git`:

```sh
config status
config add ~/.zshrc
config commit -m "update zshrc"
config push
```

## What's included

| File | Purpose |
|------|---------|
| `.zshrc` | Shell config, plugins, aliases, functions |
| `.zprofile` | Login shell (Homebrew PATH) |
| `.gitconfig` | Git identity and credential helper |
| `.config/starship.toml` | Starship prompt |
| `.config/op/plugins.sh` | 1Password CLI plugin aliases (`aws` → `op plugin run`) |
| `.config/op/plugins/aws.json` | 1Password AWS plugin config (references item by ID, no secrets) |
| `.aws/config` | AWS CLI region and output defaults |
| `.aws/credentials.template` | Credentials setup instructions (actual credentials via op plugin) |
| `Brewfile` | All Homebrew packages and casks |

## Local overrides

Machine-specific or secret config goes in `~/.localrc` — it's sourced by `.zshrc` if it exists, but never tracked.
