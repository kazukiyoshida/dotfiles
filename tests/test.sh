#!/bin/bash
set -e

PASS=0
FAIL=0
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "  PASS: $desc"
    ((PASS++))
  else
    echo "  FAIL: $desc"
    ((FAIL++))
  fi
}

echo "=== Dotfiles Test Suite (macOS) ==="

# ---------------------------------------------------------------------------
echo ""
echo "[link.sh]"

# 1回目: エラーなく完了すること
check "link.sh runs without error" bash "$SCRIPT_DIR/bin/link.sh"

# 2回目: 冪等性 (再実行してもエラーにならない)
check "link.sh is idempotent (2nd run)" bash "$SCRIPT_DIR/bin/link.sh"

# ---------------------------------------------------------------------------
echo ""
echo "[zsh]"

# zshrc が読み込み可能なシンボリックリンクか
check ".zshrc is a valid symlink" test -L "$HOME/.zshrc" -a -r "$HOME/.zshrc"

# 構文エラーがないか
check "zshrc parses without error" zsh -n "$HOME/.zshrc"
check "zprofile parses without error" zsh -n "$HOME/.zprofile"

# EDITOR が設定されているか (zshrc で export している)
check "EDITOR is set via zshrc" zsh -c "source \"\$HOME/.zshrc\" 2>/dev/null; [ -n \"\$EDITOR\" ]"

# ---------------------------------------------------------------------------
echo ""
echo "[tmux]"

# 設定ファイルが読み込み可能か
check ".tmux.conf is a valid symlink" test -L "$HOME/.tmux.conf" -a -r "$HOME/.tmux.conf"

# tmux が設定を構文エラーなく読み込めるか
check "tmux.conf parses without error" tmux -f "$HOME/.tmux.conf" start-server \; kill-server

# prefix が C-q に設定されているか
check "tmux prefix is C-q" grep -q 'set -g prefix C-q' "$HOME/.tmux.conf"

# ---------------------------------------------------------------------------
echo ""
echo "[nvim]"

# init.vim が読み込み可能か
check "nvim/init.vim is a valid symlink" test -L "$HOME/.config/nvim/init.vim" -a -r "$HOME/.config/nvim/init.vim"

# 設定ディレクトリが揃っているか
check "_config dir linked" test -L "$HOME/.config/nvim/_config" -a -d "$HOME/.config/nvim/_config"
check "autoload dir linked" test -L "$HOME/.config/nvim/autoload" -a -d "$HOME/.config/nvim/autoload"
check "plugin dir linked" test -L "$HOME/.config/nvim/plugin" -a -d "$HOME/.config/nvim/plugin"
check "dein.toml linked" test -L "$HOME/.config/nvim/dein.toml" -a -r "$HOME/.config/nvim/dein.toml"
check "dein_lazy.toml linked" test -L "$HOME/.config/nvim/dein_lazy.toml" -a -r "$HOME/.config/nvim/dein_lazy.toml"

# nvim が設定を読み込んでエラーなく起動・終了できるか
check "nvim loads config without error" nvim --headless -c 'qall' 2>&1

# ---------------------------------------------------------------------------
echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
