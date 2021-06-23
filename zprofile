echo "---- zprofile ----"

eval $(/opt/homebrew/bin/brew shellenv)

if [ -z "$TMUX" ]; then
  tmux
fi
