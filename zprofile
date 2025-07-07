# echo "---- zprofile ----"

eval $(/opt/homebrew/bin/brew shellenv)

if [ -z "$TMUX" ]; then
  tmux
fi
export PATH="/Users/jp29070/.local/bin:/Users/jp29070/go/bin:/Users/jp29070/.rd/bin:/Users/jp29070/.rye/shims:/usr/local/var/nodebrew/current/bin:/Users/jp29070/.nodenv/shims:/Users/jp29070/.pyenv/shims:/Users/jp29070/.pyenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/Users/jp29070/.cargo/bin:/Users/jp29070/bin:/Users/jp29070/.krew/bin:/usr/local/opt/mysql/bin:/Users/jp29070/.vector/bin"
