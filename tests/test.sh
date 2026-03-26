#!/bin/bash
# test.sh - ローカル簡易テスト (ツール不要、どの環境でも動く)
# 実行タイミング: pre-push hook (make test)
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

echo "=== Dotfiles Test (local) ==="

# ---------------------------------------------------------------------------
echo ""
echo "[link.sh]"

check "link.sh runs without error" bash "$SCRIPT_DIR/bin/link.sh"
check "link.sh is idempotent (2nd run)" bash "$SCRIPT_DIR/bin/link.sh"

# ---------------------------------------------------------------------------
echo ""
echo "[symlinks]"

check ".zshrc linked"             test -L "$HOME/.zshrc"           -a -r "$HOME/.zshrc"
check ".zprofile linked"          test -L "$HOME/.zprofile"        -a -r "$HOME/.zprofile"
check ".tmux.conf linked"         test -L "$HOME/.tmux.conf"       -a -r "$HOME/.tmux.conf"
check ".tigrc linked"             test -L "$HOME/.tigrc"           -a -r "$HOME/.tigrc"
check "nvim/init.vim linked"      test -L "$HOME/.config/nvim/init.vim"      -a -r "$HOME/.config/nvim/init.vim"
check "nvim/_config linked"       test -L "$HOME/.config/nvim/_config"       -a -d "$HOME/.config/nvim/_config"
check "nvim/autoload linked"      test -L "$HOME/.config/nvim/autoload"      -a -d "$HOME/.config/nvim/autoload"
check "nvim/plugin linked"        test -L "$HOME/.config/nvim/plugin"        -a -d "$HOME/.config/nvim/plugin"
check "nvim/dein.toml linked"     test -L "$HOME/.config/nvim/dein.toml"     -a -r "$HOME/.config/nvim/dein.toml"
check "nvim/dein_lazy.toml linked" test -L "$HOME/.config/nvim/dein_lazy.toml" -a -r "$HOME/.config/nvim/dein_lazy.toml"
check "peco/config.json linked"   test -L "$HOME/.config/peco/config.json"   -a -r "$HOME/.config/peco/config.json"

# ---------------------------------------------------------------------------
echo ""
echo "[config content]"

check "tmux prefix is C-q"        grep -q 'set -g prefix C-q' "$HOME/.tmux.conf"
check "EDITOR=vim in zshrc"        grep -q 'EDITOR="vim"' "$HOME/.zshrc"
check "nvim loads _config via glob" grep -q 'globpath' "$HOME/.config/nvim/init.vim"

# ---------------------------------------------------------------------------
echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
