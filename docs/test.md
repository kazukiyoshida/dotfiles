# テスト構成

テストは 3 層構造になっている。

```
git commit  ──→  pre-commit hook  ──→  make lint        (静的解析)
git push    ──→  pre-push hook    ──→  make test        (lint + test.sh)
push/PR     ──→  GitHub Actions   ──→  e2etest.sh       (macOS フル検証)
```

## Layer 1: lint (pre-commit)

コミットのたびに自動実行。構文レベルのチェックのみ。

| チェック | コマンド |
|---------|---------|
| shellcheck | `shellcheck bin/link.sh tests/test.sh tests/e2etest.sh` |
| zsh 構文 | `zsh -n config/zsh/{zshrc,zprofile,zshenv,zlogin}` |

## Layer 2: test.sh (pre-push)

push のたびに自動実行。外部ツール不要でどの環境でも動く。

| チェック | 内容 |
|---------|------|
| link.sh 実行 | エラーなく完了する |
| link.sh ��等性 | 2 回目の実行もエラーにならない |
| symlink 確認 | 全 symlink が存在し読み込み可能 |
| 設定内容 | tmux prefix=C-q, EDITOR=vim 等が grep で確認できる |

## Layer 3: e2etest.sh (GitHub Actions)

push / PR で GitHub Actions が `macos-latest` ランナー上で実行。
zsh, tmux, nvim 等の実際のツールを使って設定の動作を検証する。

| チェック | 内容 |
|---------|------|
| deploy | link.sh 実行 + 冪等性 |
| zsh | zshrc/zprofile/zshenv/zlogin の構文、EDITOR 設定確認 |
| tmux | tmux.conf の構文パース、prefix 確認 |
| nvim | 全 symlink + `nvim --headless` で設定読み込み確認 |
| tig | tigrc symlink 確認 |
| peco | config.json symlink + JSON 検証 |

### ワークフロー

- ファイル: `.github/workflows/e2e.yml`
- トリガー: master / refactor/** への push、master への PR
- ランナー: `macos-latest`
- 依存ツール: `brew install neovim tmux tig peco fzf ripgrep`
