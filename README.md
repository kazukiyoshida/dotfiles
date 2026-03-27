# dotfiles

Personal dotfiles for macOS.

## Quick Start

```sh
curl -fsSL https://raw.githubusercontent.com/kazukiyoshida/dotfiles/master/setup.sh | bash
```

This will clone the repo, install Homebrew and required tools, and create all symlinks.

## Manual Setup

```sh
# 1. Clone
git clone https://github.com/kazukiyoshida/dotfiles.git
cd dotfiles

# 2. Deploy (create symlinks)
make deploy
```

## Tools

| Tool | Purpose |
|------|---------|
| [Homebrew](https://brew.sh/) | Package manager |
| [Neovim](https://neovim.io/) | Editor (aliased to `vim` / `vi` / `v`) |
| [tig](https://jonas.github.io/tig/) | Git TUI |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer (prefix: `C-q`) |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder (`C-r`: history search) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep (used by Neovim) |
| [Ghostty](https://ghostty.org/) | Terminal emulator |

## Structure

```
config/
  zsh/           zshrc, zprofile
  nvim/          init.vim, _config/, autoload/, dein/, plugin/
  tmux/          tmux.conf
  tig/           tigrc
  ghostty/       config
setup.sh         One-liner setup script
link.sh          Deploy script (creates symlinks)
test.sh          E2E tests (GitHub Actions)
pre-commit       Git hook (shellcheck + zsh syntax)
docs/            Documentation
```

## Dev

```sh
make init     # install git hooks
```
