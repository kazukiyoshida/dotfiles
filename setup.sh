#!/bin/bash
#
# One-liner setup (run on a fresh macOS):
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/kazukiyoshida/dotfiles/master/setup.sh)"
#
# Idempotent: safe to run multiple times.
#
set -eu

DOTFILES_REPO="https://github.com/kazukiyoshida/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
BREW_FORMULAE="neovim tmux fzf ripgrep tig shellcheck"
BREW_CASKS="ghostty"

info() { printf '\033[0;36m[info]\033[0m  %s\n' "$1"; }
ok()   { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }
warn() { printf '\033[0;33m[warn]\033[0m  %s\n' "$1"; }

echo ""
echo "This script will:"
echo "  1. Install Xcode Command Line Tools (if not already installed)"
echo "  2. Clone dotfiles to $DOTFILES_DIR"
echo "  3. Install Homebrew (if not already installed)"
echo "  4. Install tools via brew: $BREW_FORMULAE"
echo "  5. Install apps via brew cask: $BREW_CASKS"
echo "  6. Create symlinks to ~/.zshrc, ~/.tmux.conf, ~/.config/nvim/, etc."
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
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done

if command -v brew &>/dev/null; then
  ok "Homebrew already installed"
else
  info "Installing Homebrew (you may be asked for your password)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" <"$TTY_IN"
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
      break
    fi
  done
  ok "Homebrew installed"
fi

# --- Required tools ---------------------------------------------------------
info "Installing tools: $BREW_FORMULAE"
# shellcheck disable=SC2086
brew install $BREW_FORMULAE

info "Installing apps: $BREW_CASKS"
# shellcheck disable=SC2086
brew install --cask $BREW_CASKS

# --- Deploy -----------------------------------------------------------------
info "Running link.sh..."
bash "$DOTFILES_DIR/link.sh"

# --- Git hooks --------------------------------------------------------------
info "Installing git hooks..."
make -C "$DOTFILES_DIR" init

echo ""
ok "Setup complete. Restart your terminal or run: source ~/.zshrc"
