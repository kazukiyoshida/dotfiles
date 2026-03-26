#!/bin/bash
set -e

PASS=0
FAIL=0

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
echo ""

# Deploy if not already deployed
if [ ! -L ~/.zshrc ]; then
  echo "[Setup] Running bin/link.sh..."
  SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
  bash "$SCRIPT_DIR/bin/link.sh"
  echo ""
fi

echo "[Symlinks]"
check "$HOME/.zshrc exists" test -L "$HOME/.zshrc"
check "$HOME/.zprofile exists" test -L "$HOME/.zprofile"
check "$HOME/.tmux.conf exists" test -L "$HOME/.tmux.conf"
check "$HOME/.tigrc exists" test -L "$HOME/.tigrc"
check "$HOME/.config/nvim/init.vim exists" test -L "$HOME/.config/nvim/init.vim"
check "$HOME/.config/nvim/_config exists" test -L "$HOME/.config/nvim/_config"
check "$HOME/.config/nvim/dein.toml exists" test -L "$HOME/.config/nvim/dein.toml"
check "$HOME/.config/nvim/dein_lazy.toml exists" test -L "$HOME/.config/nvim/dein_lazy.toml"
check "$HOME/.config/nvim/autoload exists" test -L "$HOME/.config/nvim/autoload"
check "$HOME/.config/nvim/plugin exists" test -L "$HOME/.config/nvim/plugin"
check "$HOME/.config/peco/config.json exists" test -L "$HOME/.config/peco/config.json"

echo ""
echo "[Syntax]"
check "zshrc syntax valid" zsh -n "$HOME/.zshrc"
check "zprofile syntax valid" zsh -n "$HOME/.zprofile"
check "peco.json valid JSON" python3 -c "import json; json.load(open('$HOME/.config/peco/config.json'))"

echo ""
echo "[macOS tools]"
check "pbcopy available" command -v pbcopy
check "brew available" command -v brew

echo ""
echo "[Idempotency]"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
bash "$SCRIPT_DIR/bin/link.sh" >/dev/null 2>&1
check "link.sh idempotent (2nd run)" bash "$SCRIPT_DIR/bin/link.sh"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
