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

# 2. Preview what will be created (dry-run)
bash link.sh --dry-run

# 3. Deploy (create symlinks)
bash link.sh

# 4. Install git hooks
make hooks
```

## What link.sh Does

Creates symlinks from the repository to your home directory.
Safe to run multiple times (idempotent). Directories are created automatically if needed.

| Source | Symlink |
|--------|---------|
| `config/zsh/zshrc` | `~/.zshrc` |
| `config/zsh/zprofile` | `~/.zprofile` |
| `config/tmux/tmux.conf` | `~/.tmux.conf` |
| `config/tig/tigrc` | `~/.config/tig/config` |
| `config/nvim/init.vim` | `~/.config/nvim/init.vim` |
| `config/nvim/dein/dein.toml` | `~/.config/nvim/dein.toml` |
| `config/nvim/dein/dein_lazy.toml` | `~/.config/nvim/dein_lazy.toml` |
| `config/nvim/_config/` | `~/.config/nvim/_config` |
| `config/nvim/autoload/` | `~/.config/nvim/autoload` |
| `config/nvim/plugin/` | `~/.config/nvim/plugin` |

## Prerequisites

### Required

| Tool | Purpose |
|------|---------|
| [Homebrew](https://brew.sh/) | Package manager |
| [Neovim](https://neovim.io/) | Editor (aliased to `vim` / `vi` / `v`) |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer (prefix: `C-q`) |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder (`C-r`: history search) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep (used by `grap` function) |
| [tig](https://jonas.github.io/tig/) | Git TUI |

### Optional

These are configured per-machine in `~/.zshrc.local` (see [docs/zshrc-local.md](docs/zshrc-local.md)).

| Tool | Purpose |
|------|---------|
| [nodenv](https://github.com/nodenv/nodenv) | Node.js version manager |
| [asdf](https://asdf-vm.com/) | Runtime version manager |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) + [krew](https://krew.sigs.k8s.io/) | Kubernetes CLI (`k` alias) |
| [kube-ps1](https://github.com/jonmosco/kube-ps1) | Kubernetes context in prompt |
| [Google Cloud SDK](https://cloud.google.com/sdk) | gcloud CLI |
| [.NET SDK](https://dotnet.microsoft.com/) | .NET development |
| [Docker](https://www.docker.com/) | Containers (`d`, `dp`, `dke` aliases) |

## Structure

```
config/
  zsh/           zshrc, zprofile
  nvim/          init.vim, _config/, autoload/, dein/, plugin/
  tmux/          tmux.conf
  tig/           tigrc
setup.sh         One-liner setup script
link.sh          Deploy script (creates symlinks)
test.sh          E2E tests (GitHub Actions)
pre-commit       Git hook (shellcheck + zsh syntax)
docs/            Documentation
```
