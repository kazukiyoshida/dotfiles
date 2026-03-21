eval $(/opt/homebrew/bin/brew shellenv)

if [ -z "$TMUX" ]; then
  tmux
fi

export PATH="/Users/yoshidakazuki/.local/share/solana/install/active_release/bin:$PATH"
