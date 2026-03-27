# Agent Development Guide

## Overview

A macOS-only dotfiles repository managing configs for zsh, neovim, tmux, tig, and ghostty.

## Commands

- **Lint (all):** `make lint`
- **Lint (shell):** `shellcheck link.sh test.sh`
- **Lint (zsh):** `zsh -n config/zsh/zshrc config/zsh/zprofile`
- **E2E test (macOS):** `make e2e`
- **Deploy:** `make deploy`
- **Init dev environment:** `make init`

## Testing

Two-layer structure. See [docs/test.md](docs/test.md) for details.

```
git commit  →  pre-commit  →  make lint        (static analysis)
push/PR     →  GitHub Actions → test.sh       (full macOS verification)
```

## Structure

```
config/                  # dotfiles (symlink targets)
  zsh/                   #   zshrc, zprofile
  nvim/                  #   init.vim, _config/, autoload/, dein/, plugin/
  tmux/                  #   tmux.conf
  tig/                   #   tigrc
  ghostty/               #   config
link.sh                  # deploy script (creates symlinks)
test.sh                  # macOS E2E tests (GitHub Actions)
pre-commit               # git pre-commit hook
docs/                    # documentation
.github/workflows/       # GitHub Actions (e2e.yml)
```

## Language

README.md, CLAUDE.md, commit messages, and code comments are in English.
Documents under the docs/ directory are in Japanese.
