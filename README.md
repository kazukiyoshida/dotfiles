# dotfiles

Personal dotfiles for macOS.

## Prerequisites

- macOS (Apple Silicon or Intel)
- An administrator account (Homebrew and Tailscale ask for your password)
- Internet access

Nothing else needs to be installed beforehand. Xcode Command Line Tools
(which provide `git`) and Homebrew are installed by the setup script if missing.

## Quick Start

Run this on a fresh Mac:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kazukiyoshida/dotfiles/master/setup.sh)"
```

The script is idempotent: every step checks whether it is already done and
skips it, so you can re-run it any time to pick up changes. It does the following:

1. Install Xcode Command Line Tools (a dialog appears; click "Install")
2. Clone this repo to `~/dotfiles`
3. Install Homebrew
4. Install everything in `Brewfile` via `brew bundle`
5. Install Claude Code and Codex via their native installers
6. Start the Tailscale daemon and make Chrome the default browser
7. Import the Rectangle config (`config/rectangle/RectangleConfig.json`)
8. Create symlinks (`link.sh`)
9. Install git hooks for this repo (`make init`)

### After setup (manual)

These need a login or a confirmation and cannot be automated:

| Step | Command |
|------|---------|
| Reload shell config | restart the terminal, or open Ghostty |
| Log in to Claude Code | `claude` |
| Log in to Codex | `codex` |
| Log in to Tailscale | `sudo tailscale up` |
| Confirm Chrome as default browser | click "Use Chrome" in the macOS dialog |
| Rectangle | allow Accessibility access, then click "Apply" to import the config |

## Tools

All of these are installed automatically by the setup script.

| Tool | Installed via | Purpose |
|------|---------------|---------|
| [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/) | `xcode-select --install` | `git`, compilers |
| [Homebrew](https://brew.sh/) | official installer | Package manager |
| [Neovim](https://neovim.io/) | Brewfile | Editor (aliased to `vim` / `vi` / `v`) |
| [tmux](https://github.com/tmux/tmux) | Brewfile | Terminal multiplexer (prefix: `C-q`) |
| [fzf](https://github.com/junegunn/fzf) | Brewfile | Fuzzy finder (`C-r`: history search) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Brewfile | Fast grep (used by Neovim) |
| [tig](https://jonas.github.io/tig/) | Brewfile | Git TUI |
| [shellcheck](https://www.shellcheck.net/) | Brewfile | Shell linter (used by the pre-commit hook) |
| [Tailscale](https://tailscale.com/) (OSS CLI) | Brewfile | Mesh VPN (`tailscaled` runs via `brew services`) |
| [defaultbrowser](https://github.com/kerma/defaultbrowser) | Brewfile | Sets Chrome as the default browser |
| [Ghostty](https://ghostty.org/) | Brewfile (cask) | Terminal emulator |
| [Google Chrome](https://www.google.com/chrome/) | Brewfile (cask) | Browser (set as default) |
| [Rectangle](https://github.com/rxhanson/Rectangle) | Brewfile (cask) | Window manager (config imported from `config/rectangle/`) |
| [Claude Code](https://claude.com/product/claude-code) | native installer | AI coding agent (`~/.local/bin/claude`, self-updating) |
| [Codex](https://github.com/openai/codex) | native installer | AI coding agent (`~/.local/bin/codex`, self-updating) |

To add a Homebrew package, add a line to `Brewfile` and re-run the setup
script (or `brew bundle --file=Brewfile`).

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
  rectangle/     RectangleConfig.json (copied, not symlinked; see setup.sh)
Brewfile         Homebrew packages (brew bundle)
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
