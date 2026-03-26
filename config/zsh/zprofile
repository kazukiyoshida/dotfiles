eval $(/opt/homebrew/bin/brew shellenv)

# Auto-start tmux
if [ -z "$TMUX" ]; then
  tmux
fi

# Solana
if [ -d "$HOME/.local/share/solana/install/active_release/bin" ]; then
  export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
fi
