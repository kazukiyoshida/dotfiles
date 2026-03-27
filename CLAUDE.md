# Agent Development Guide

## Overview

macOS 専用の dotfiles リポジトリ。zsh, neovim, tmux, tig, ghostty の設定を管理する。

## Commands

- **Lint (all):** `make lint`
- **Lint (shell):** `shellcheck link.sh test.sh`
- **Lint (zsh):** `zsh -n config/zsh/zshrc config/zsh/zprofile`
- **E2E test (macOS):** `make e2e`
- **Deploy:** `make deploy`
- **Init dev environment:** `make init`

## Testing

2層構造。詳細は [docs/test.md](docs/test.md) を参照。

```
git commit  →  pre-commit  →  make lint       (静的解析)
push/PR     →  GitHub Actions → test.sh      (macOS フル検証)
```

## Structure

```
config/                  # symlink対象のdotfiles
  zsh/                   #   zshrc, zprofile
  nvim/                  #   init.vim, _config/, autoload/, dein/, plugin/
  tmux/                  #   tmux.conf
  tig/                   #   tigrc
  ghostty/               #   config
link.sh                  # デプロイスクリプト (symlink作成)
test.sh                  # macOS E2E テスト (GitHub Actions)
pre-commit               # git pre-commit hook
docs/                    # ドキュメント
.github/workflows/       # GitHub Actions (e2e.yml)
```

## Language

README.md, CLAUDE.md, commit メッセージ, コードコメントは英語.
docs ディレクトリ配下のドキュメントは日本語.
