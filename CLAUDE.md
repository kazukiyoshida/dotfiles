# Agent Development Guide

A file for [guiding coding agents](https://agents.md/).

## Overview

macOS 専用の dotfiles リポジトリ。zsh, neovim, tmux, tig, peco の設定を管理する。

## Commands

- **Lint (all):** `make lint`
- **Lint (shell):** `shellcheck bin/link.sh tests/test.sh`
- **Lint (zsh):** `zsh -n zshrc zprofile zshenv zlogin`
- **Lint (json):** `python3 -c "import json; json.load(open('peco.json'))"`
- **Test:** `make test`
- **Deploy:** `make deploy`
- **Dry-run deploy:** `make dry-run`
- **Install git hooks:** `make hooks`

## Git Hooks

`make hooks` で hooks/ 配下のスクリプトを .git/hooks にインストールする。

- **pre-commit:** `make lint` を実行（shellcheck, zsh構文, JSON検証）
- **pre-push:** `make test` を実行（lint + tests/test.sh）

## Testing

### ローカル

```sh
make lint   # 静的解析のみ
make test   # lint + テスト実行
```

### macOS VM (dockur/macos)

```sh
make vm-up   # VM起動 → http://localhost:8006
# VM内のTerminalで:
#   sudo mount_9p shared
#   cd /Volumes/shared && bash tests/test.sh
make vm-down # VM停止
```

## Structure

```
bin/link.sh          # デプロイスクリプト (symlink作成)
hooks/pre-commit     # git pre-commit hook
hooks/pre-push       # git pre-push hook
tests/test.sh        # テストスイート
docker-compose.yml   # macOS テスト VM
zshrc, zprofile, ... # dotfiles本体
vimfiles/            # neovim設定
```
