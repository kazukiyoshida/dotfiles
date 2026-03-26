#!/bin/sh

set -eu

# ---------------------------------------------------------------------------
# Dotfiles deploy script
#   Idempotent: safe to run multiple times.
#   Usage: ./link.sh [--dry-run]
# ---------------------------------------------------------------------------

# --- Resolve DOTFILES_DIR (directory containing this script) ---------------
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Options ---------------------------------------------------------------
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *)
      echo "Usage: $0 [--dry-run]" >&2
      exit 1
      ;;
  esac
done

# --- Colors (only when stdout is a terminal) --------------------------------
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  CYAN='\033[0;36m'
  RESET='\033[0m'
else
  GREEN='' YELLOW='' CYAN='' RESET=''
fi

info()  { printf "${CYAN}[info]${RESET}  %s\n" "$1"; }
ok()    { printf "${GREEN}[ok]${RESET}    %s\n" "$1"; }
skip()  { printf "${YELLOW}[skip]${RESET}  %s\n" "$1"; }

# --- Helpers ----------------------------------------------------------------

# link_file SRC DEST
#   For regular files: remove any existing symlink/file at DEST, then symlink.
link_file() {
  src="$1"
  dest="$2"

  if [ ! -e "$src" ]; then
    skip "source does not exist: $src"
    return
  fi

  if $DRY_RUN; then
    info "(dry-run) $src -> $dest"
    return
  fi

  if [ -L "$dest" ] || [ -e "$dest" ]; then
    rm -f "$dest"
  fi
  ln -s "$src" "$dest"
  ok "$src -> $dest"
}

# link_dir SRC DEST
#   For directories: ln -sfn handles replacing an existing directory symlink.
link_dir() {
  src="$1"
  dest="$2"

  if [ ! -d "$src" ]; then
    skip "source directory does not exist: $src"
    return
  fi

  if $DRY_RUN; then
    info "(dry-run) $src -> $dest"
    return
  fi

  ln -sfn "$src" "$dest"
  ok "$src -> $dest"
}

# ensure_dir DIR
#   Create directory (and parents) if it doesn't exist.
ensure_dir() {
  if [ ! -d "$1" ]; then
    if $DRY_RUN; then
      info "(dry-run) mkdir -p $1"
    else
      mkdir -p "$1"
      info "created directory $1"
    fi
  fi
}

# ---------------------------------------------------------------------------
# Deploy
# ---------------------------------------------------------------------------

echo ""
info "DOTFILES_DIR = $DOTFILES_DIR"
echo ""

# --- config directory -------------------------------------------------------
CONF="$DOTFILES_DIR/config"

# --- Shell -----------------------------------------------------------------
info "Linking shell config..."
for f in zshrc zprofile; do
  link_file "$CONF/zsh/$f" "$HOME/.$f"
done

# --- Tmux ------------------------------------------------------------------
info "Linking tmux config..."
link_file "$CONF/tmux/tmux.conf" "$HOME/.tmux.conf"

# --- Tig -------------------------------------------------------------------
info "Linking tig config..."
link_file "$CONF/tig/tigrc" "$HOME/.tigrc"

# --- Neovim ----------------------------------------------------------------
info "Linking Neovim config..."
ensure_dir "$HOME/.config/nvim"

link_file "$CONF/nvim/init.vim" "$HOME/.config/nvim/init.vim"

link_file "$CONF/nvim/dein/dein.toml"      "$HOME/.config/nvim/dein.toml"
link_file "$CONF/nvim/dein/dein_lazy.toml"  "$HOME/.config/nvim/dein_lazy.toml"

link_dir "$CONF/nvim/_config"  "$HOME/.config/nvim/_config"
link_dir "$CONF/nvim/autoload" "$HOME/.config/nvim/autoload"
link_dir "$CONF/nvim/plugin"   "$HOME/.config/nvim/plugin"

# --- Tig (XDG) -------------------------------------------------------------
info "Linking tig XDG config..."
ensure_dir "$HOME/.config/tig"
link_file "$CONF/tig/tigrc" "$HOME/.config/tig/config"

echo ""
info "Done."
