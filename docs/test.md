# テスト構成

テストは 2 層構造になっている。

```
git commit  ──→  pre-commit hook  ──→  make lint        (静的解析)
push/PR     ──→  GitHub Actions   ──→  test.sh          (macOS フル検証)
```

## Layer 1: lint (pre-commit)

コミットのたびに自動実行。構文レベルのチェックのみ。

| チェック | コマンド |
|---------|---------|
| shellcheck | `shellcheck link.sh test.sh` |
| zsh 構文 | `zsh -n config/zsh/{zshrc,zprofile,zshenv,zlogin}` |

## Layer 2: test.sh (GitHub Actions)

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
