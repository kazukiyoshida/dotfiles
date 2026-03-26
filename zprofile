# Homebrew
if [ -f /opt/homebrew/bin/brew ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# Auto-start tmux
if [ -z "$TMUX" ]; then
  tmux
fi

# Solana
if [ -d "$HOME/.local/share/solana/install/active_release/bin" ]; then
  export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
fi
