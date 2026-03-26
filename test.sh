#!/bin/bash
# test.sh - macOS 上での E2E テスト (zsh, tmux, nvim が必要)
# 実行タイミング: GitHub Actions (macos-latest)
set -e

PASS=0
FAIL=0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "  PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Dotfiles E2E Test (macOS) ==="

# ---------------------------------------------------------------------------
echo ""
echo "[deploy]"

check "link.sh runs without error" bash "$SCRIPT_DIR/link.sh"
check "link.sh is idempotent (2nd run)" bash "$SCRIPT_DIR/link.sh"

# ---------------------------------------------------------------------------
echo ""
echo "[zsh]"

check ".zshrc linked"              test -L "$HOME/.zshrc" -a -r "$HOME/.zshrc"
check ".zprofile linked"           test -L "$HOME/.zprofile" -a -r "$HOME/.zprofile"
check "zshrc parses without error"  zsh -n "$HOME/.zshrc"
check "zprofile parses without error" zsh -n "$HOME/.zprofile"
check "EDITOR is set via zshrc"     zsh -c "source \"\$HOME/.zshrc\" 2>/dev/null; [ \"\$EDITOR\" = vim ]"

# ---------------------------------------------------------------------------
echo ""
echo "[tmux]"

check ".tmux.conf linked"          test -L "$HOME/.tmux.conf" -a -r "$HOME/.tmux.conf"
check "tmux.conf parses without error" tmux -f "$HOME/.tmux.conf" start-server \; kill-server
check "tmux prefix is C-q"         grep -q 'set -g prefix C-q' "$HOME/.tmux.conf"

# ---------------------------------------------------------------------------
echo ""
echo "[nvim]"

check "nvim/init.vim linked"       test -L "$HOME/.config/nvim/init.vim" -a -r "$HOME/.config/nvim/init.vim"
check "nvim/_config linked"        test -L "$HOME/.config/nvim/_config" -a -d "$HOME/.config/nvim/_config"
check "nvim/autoload linked"       test -L "$HOME/.config/nvim/autoload" -a -d "$HOME/.config/nvim/autoload"
check "nvim/plugin linked"         test -L "$HOME/.config/nvim/plugin" -a -d "$HOME/.config/nvim/plugin"
check "nvim/dein.toml linked"      test -L "$HOME/.config/nvim/dein.toml" -a -r "$HOME/.config/nvim/dein.toml"
check "nvim/dein_lazy.toml linked" test -L "$HOME/.config/nvim/dein_lazy.toml" -a -r "$HOME/.config/nvim/dein_lazy.toml"
check "nvim loads config without error" nvim --headless -c 'qall'

# ---------------------------------------------------------------------------
echo ""
echo "[tig]"

check "tig/config linked"          test -L "$HOME/.config/tig/config" -a -r "$HOME/.config/tig/config"

# ---------------------------------------------------------------------------
echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
