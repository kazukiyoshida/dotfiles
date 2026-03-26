# Agent Development Guide

A file for [guiding coding agents](https://agents.md/).

## Overview

macOS 専用の dotfiles リポジトリ。zsh, neovim, tmux, tig, peco の設定を管理する。

## Commands

- **Lint (all):** `make lint`
- **Lint (shell):** `shellcheck link.sh test.sh`
- **Lint (zsh):** `zsh -n config/zsh/zshrc config/zsh/zprofile config/zsh/zshenv config/zsh/zlogin`
- **E2E test (macOS):** `make e2e`
- **Deploy:** `make deploy`
- **Dry-run deploy:** `make dry-run`
- **Install git hooks:** `make hooks`

## Git Hooks

`make hooks` で pre-commit スクリプトを .git/hooks にインストールする。

- **pre-commit:** `make lint` を実行（shellcheck, zsh構文）

## Testing

2層構造。詳細は [docs/test.md](docs/test.md) を参照。

```
git commit  →  pre-commit  →  make lint       (静的解析)
push/PR     →  GitHub Actions → test.sh      (macOS フル検証)
```

## Structure

```
config/                  # symlink対象のdotfiles
  zsh/                   #   zshrc, zprofile, zshenv, zlogin
  nvim/                  #   init.vim, _config/, autoload/, dein/, plugin/
  tmux/                  #   tmux.conf
  tig/                   #   tigrc
  peco/                  #   config.json
link.sh                  # デプロイスクリプト (symlink作成)
test.sh                  # macOS E2E テスト (GitHub Actions)
pre-commit               # git pre-commit hook
docs/                    # ドキュメント
.github/workflows/       # GitHub Actions (e2e.yml)
```
