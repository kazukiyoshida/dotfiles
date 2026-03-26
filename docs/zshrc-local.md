# ~/.zshrc.local

PC固有の設定を書くファイル。zshrc の末尾で `source ~/.zshrc.local` される。
git 管理されないので、マシンごとに自由に書いてよい。

## Example

```zsh
# --- SSH agent ---
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# --- nodenv ---
if command -v nodenv &>/dev/null; then
  eval "$(nodenv init -)"
fi

# --- asdf ---
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# --- kubectl / krew ---
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# kube-ps1
local kube_ps1_path="/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
if [ -f "$kube_ps1_path" ]; then
  source "$kube_ps1_path"
  PROMPT='$(kube_ps1)'$PROMPT
fi

# --- Google Cloud SDK ---
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# --- .NET ---
export DOTNET_ROOT=/usr/local/share/dotnet
export PATH=$DOTNET_ROOT:$PATH
export PATH="$PATH:$HOME/.dotnet/tools"
```
