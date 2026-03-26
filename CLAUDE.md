# Agent Development Guide

A file for [guiding coding agents](https://agents.md/).

## Overview

macOS 専用の dotfiles リポジトリ。zsh, neovim, tmux, tig, peco の設定を管理する。

## Commands

- **Lint (all):** `make lint`
- **Lint (shell):** `shellcheck bin/link.sh tests/test.sh tests/e2etest.sh`
- **Lint (zsh):** `zsh -n config/zsh/zshrc config/zsh/zprofile config/zsh/zshenv config/zsh/zlogin`
- **Test (local):** `make test`
- **Test (e2e, macOS):** `make e2e`
- **Deploy:** `make deploy`
- **Dry-run deploy:** `make dry-run`
- **Install git hooks:** `make hooks`

## Git Hooks

`make hooks` で hooks/ 配下のスクリプトを .git/hooks にインストールする。

- **pre-commit:** `make lint` を実行（shellcheck, zsh構文）
- **pre-push:** `make test` を実行（lint + tests/test.sh）

## Testing

3層構造。詳細は [docs/test.md](docs/test.md) を参照。

```
git commit  →  pre-commit  →  make lint       (静的解析)
git push    →  pre-push    →  make test        (lint + test.sh)
push/PR     →  GitHub Actions → e2etest.sh    (macOS フル検証)
```

## Structure

```
config/                  # symlink対象のdotfiles
  zsh/                   #   zshrc, zprofile, zshenv, zlogin
  nvim/                  #   init.vim, _config/, autoload/, dein/, plugin/
  tmux/                  #   tmux.conf
  tig/                   #   tigrc
  peco/                  #   config.json
bin/link.sh              # デプロイスクリプト (symlink作成)
hooks/                   # git hooks (pre-commit, pre-push)
tests/
  test.sh                # ローカル簡易テスト
  e2etest.sh             # macOS E2E テスト (GitHub Actions)
docs/                    # ドキュメント
.github/workflows/       # GitHub Actions (e2e.yml)
```
