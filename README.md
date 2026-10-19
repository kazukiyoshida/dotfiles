# dotfiles

Personal dotfiles for macOS.

## Prerequisites

- macOS (Apple Silicon or Intel)
- An administrator account (Homebrew asks for your password during install)
- Internet access

Nothing else needs to be installed beforehand. Xcode Command Line Tools
(which provide `git`) and Homebrew are installed by the setup script if missing.

## Quick Start

Run this on a fresh Mac:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kazukiyoshida/dotfiles/master/setup.sh)"
```

The script is idempotent and does the following:

1. Install Xcode Command Line Tools (a dialog appears; click "Install")
2. Clone this repo to `~/dotfiles`
3. Install Homebrew
4. Install the tools listed below via `brew install` / `brew install --cask`
5. Create symlinks (`link.sh`)
6. Install git hooks for this repo (`make init`)

## Tools

All of these are installed automatically by the setup script.

| Tool | Installed via | Purpose |
|------|---------------|---------|
| [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/) | `xcode-select --install` | `git`, compilers |
| [Homebrew](https://brew.sh/) | official installer | Package manager |
| [Neovim](https://neovim.io/) | `brew` | Editor (aliased to `vim` / `vi` / `v`) |
| [tmux](https://github.com/tmux/tmux) | `brew` | Terminal multiplexer (prefix: `C-q`) |
| [fzf](https://github.com/junegunn/fzf) | `brew` | Fuzzy finder (`C-r`: history search) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `brew` | Fast grep (used by Neovim) |
| [tig](https://jonas.github.io/tig/) | `brew` | Git TUI |
| [shellcheck](https://www.shellcheck.net/) | `brew` | Shell linter (used by the pre-commit hook) |
| [Ghostty](https://ghostty.org/) | `brew --cask` | Terminal emulator |

## Manual Setup

If you already have git and the tools above:

```sh
# 1. Clone
git clone https://github.com/kazukiyoshida/dotfiles.git
cd dotfiles

# 2. Deploy (create symlinks)
make deploy
```

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
make lint     # shellcheck + zsh syntax check
make e2e      # E2E tests (macOS)
```
