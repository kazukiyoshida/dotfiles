#!/bin/bash
#
# One-liner setup (run on a fresh macOS):
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/kazukiyoshida/dotfiles/master/setup.sh)"
#
# Idempotent: safe to run multiple times. Every step checks whether its work
# is already done and skips it if so.
#
set -eu

DOTFILES_REPO="https://github.com/kazukiyoshida/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

info() { printf '\033[0;36m[info]\033[0m  %s\n' "$1"; }
ok()   { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }
warn() { printf '\033[0;33m[warn]\033[0m  %s\n' "$1"; }

echo ""
echo "This script will:"
echo "  1. Install Xcode Command Line Tools (if not already installed)"
echo "  2. Clone dotfiles to $DOTFILES_DIR"
echo "  3. Install Homebrew (if not already installed)"
echo "  4. Install packages listed in Brewfile (brew bundle)"
echo "  5. Install Claude Code and Codex via their native installers"
echo "  6. Start the Tailscale daemon and make Chrome the default browser"
echo "  7. Import the Rectangle config"
echo "  8. Create symlinks to ~/.zshrc, ~/.tmux.conf, ~/.config/nvim/, etc."
echo ""

# --- Terminal input -----------------------------------------------------------
# When run as `curl ... | bash`, stdin is the script itself, not the terminal.
# Interactive installers (Homebrew asks for the sudo password) need a real
# terminal, so reattach their stdin to /dev/tty when one is available.
TTY_IN=/dev/stdin
if [ ! -t 0 ] && { : </dev/tty; } 2>/dev/null; then
  TTY_IN=/dev/tty
fi

# --- Xcode Command Line Tools ---------------------------------------------
# A fresh macOS ships a stub `git` that only offers to install the Command
# Line Tools, so this must come before anything that calls git.
if xcode-select -p &>/dev/null; then
  ok "Xcode Command Line Tools already installed"
else
  info "Installing Xcode Command Line Tools..."
  info "A dialog will appear. Click \"Install\" and wait for it to finish."
  xcode-select --install 2>/dev/null || true
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  ok "Xcode Command Line Tools installed"
fi

# --- Clone dotfiles ---------------------------------------------------------
if [ -d "$DOTFILES_DIR" ]; then
  info "Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull
else
  info "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# --- Homebrew ---------------------------------------------------------------
# brew may be installed but not yet on PATH (e.g. zprofile not loaded yet).
load_brew() {
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
      return 0
    fi
  done
  return 1
}

if load_brew; then
  ok "Homebrew already installed"
else
  info "Installing Homebrew (you may be asked for your password)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" <"$TTY_IN"
  load_brew
  ok "Homebrew installed"
fi

# --- Brewfile ---------------------------------------------------------------
info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# --- Native installers ------------------------------------------------------
# Claude Code and Codex install into ~/.local/bin and update themselves.
# Re-running their installers is harmless but slow, so skip when present.
export PATH="$HOME/.local/bin:$PATH"

if command -v claude &>/dev/null; then
  ok "Claude Code already installed ($(claude --version 2>/dev/null || echo unknown))"
else
  info "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
  ok "Claude Code installed"
fi

if command -v codex &>/dev/null; then
  ok "Codex already installed ($(codex --version 2>/dev/null || echo unknown))"
else
  info "Installing Codex..."
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
  ok "Codex installed"
fi

# --- Tailscale daemon -------------------------------------------------------
# The OSS tailscaled needs root, hence `sudo brew services`.
if sudo brew services info tailscale --json 2>/dev/null | grep -q '"running": *true'; then
  ok "Tailscale daemon already running"
else
  info "Starting Tailscale daemon (you may be asked for your password)..."
  sudo brew services start tailscale
  ok "Tailscale daemon started"
fi

# --- Default browser --------------------------------------------------------
# macOS always asks for confirmation here; this just triggers the dialog.
info "Setting Chrome as the default browser (confirm the dialog if shown)..."
defaultbrowser chrome || warn "Could not set default browser; set it in System Settings > Desktop & Dock"

# --- Rectangle config -------------------------------------------------------
# Rectangle imports ~/Library/Application Support/Rectangle/RectangleConfig.json
# on launch (after asking for confirmation) and then renames it with a
# timestamp. It refuses symlinks, so the file is copied, not linked. A hash of
# the last imported config is kept so re-runs only import when it changed.
RECT_SRC="$DOTFILES_DIR/config/rectangle/RectangleConfig.json"
RECT_DIR="$HOME/Library/Application Support/Rectangle"
RECT_STAMP="$RECT_DIR/.dotfiles-config.sha256"
rect_sha="$(shasum -a 256 "$RECT_SRC" | cut -d' ' -f1)"

if [ -f "$RECT_STAMP" ] && [ "$(cat "$RECT_STAMP")" = "$rect_sha" ]; then
  ok "Rectangle config already imported"
else
  info "Importing Rectangle config (click \"Apply\" in the Rectangle dialog)..."
  mkdir -p "$RECT_DIR"
  cp "$RECT_SRC" "$RECT_DIR/RectangleConfig.json"
  chmod 644 "$RECT_DIR/RectangleConfig.json"
  # The file is only read at launch, so restart Rectangle if it is running.
  osascript -e 'tell application "Rectangle" to quit' &>/dev/null || true
  sleep 1
  open -a Rectangle
  echo "$rect_sha" >"$RECT_STAMP"
  ok "Rectangle config staged for import"
fi

# --- Deploy -----------------------------------------------------------------
info "Running link.sh..."
bash "$DOTFILES_DIR/link.sh"

# --- Git hooks --------------------------------------------------------------
info "Installing git hooks..."
make -C "$DOTFILES_DIR" init

echo ""
ok "Setup complete."
echo ""
echo "Next steps (manual):"
echo "  - Restart your terminal (or open Ghostty) to load the new shell config"
echo "  - claude        # log in to Claude Code"
echo "  - codex         # log in to Codex"
echo "  - sudo tailscale up   # log in to Tailscale"
echo "  - Confirm Chrome as the default browser if macOS asked"
echo "  - Rectangle: allow Accessibility access when prompted, then click \"Apply\" to import the config"
echo ""
