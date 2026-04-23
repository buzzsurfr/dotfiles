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

Then open a new terminal.

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
| `Brewfile` | All Homebrew packages and casks |

## Local overrides

Machine-specific or secret config goes in `~/.localrc` — it's sourced by `.zshrc` if it exists, but never tracked.
