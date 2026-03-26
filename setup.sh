#!/bin/bash
#
# One-liner setup:
#   curl -fsSL https://raw.githubusercontent.com/kazukiyoshida/dotfiles/master/setup.sh | bash
#
set -eu

DOTFILES_REPO="https://github.com/kazukiyoshida/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
BREW_PACKAGES="neovim tmux fzf ripgrep tig"

info() { printf '\033[0;36m[info]\033[0m  %s\n' "$1"; }
ok()   { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }

echo ""
echo "This script will:"
echo "  1. Clone dotfiles to $DOTFILES_DIR"
echo "  2. Install Homebrew (if not already installed)"
echo "  3. Install tools via brew: $BREW_PACKAGES"
echo "  4. Create symlinks to ~/.zshrc, ~/.tmux.conf, ~/.config/nvim/, etc."
echo ""

# --- Clone dotfiles ---------------------------------------------------------
if [ -d "$DOTFILES_DIR" ]; then
  info "Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull
else
  info "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# --- Homebrew ---------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ok "Homebrew installed"
else
  ok "Homebrew already installed"
fi

# --- Required tools ---------------------------------------------------------
info "Installing tools: $BREW_PACKAGES"
# shellcheck disable=SC2086
brew install $BREW_PACKAGES

# --- Deploy -----------------------------------------------------------------
info "Running link.sh..."
bash "$DOTFILES_DIR/link.sh"

# --- Git hooks --------------------------------------------------------------
info "Installing git hooks..."
make -C "$DOTFILES_DIR" hooks

echo ""
ok "Setup complete. Restart your terminal or run: source ~/.zshrc"
