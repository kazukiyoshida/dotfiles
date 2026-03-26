# Agent Development Guide

A file for [guiding coding agents](https://agents.md/).

## Overview

macOS 専用の dotfiles リポジトリ。zsh, neovim, tmux, tig, peco の設定を管理する。

## Commands

- **Lint (all):** `make lint`
- **Lint (shell):** `shellcheck bin/link.sh tests/test.sh`
- **Lint (zsh):** `zsh -n config/zsh/zshrc config/zsh/zprofile config/zsh/zshenv config/zsh/zlogin`
- **Lint (json):** `python3 -c "import json; json.load(open('config/peco/config.json'))"`
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
config/                  # symlink対象のdotfiles
  zsh/                   #   zshrc, zprofile, zshenv, zlogin
  nvim/                  #   init.vim, _config/, autoload/, dein/, plugin/
  tmux/                  #   tmux.conf
  tig/                   #   tigrc
  peco/                  #   config.json
bin/link.sh              # デプロイスクリプト (symlink作成)
hooks/                   # git hooks (pre-commit, pre-push)
tests/test.sh            # テストスイート
docs/                    # メモ (vim.md, zsh.md)
docker-compose.yml       # macOS テスト VM
```
