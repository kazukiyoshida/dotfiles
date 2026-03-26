#!/bin/zsh

#---------------------------------------------------------------------------------
# Shell Options
#---------------------------------------------------------------------------------

# Update default file permissions
umask 022

# No coredump file
limit coredumpsize 0

# Notify background task completion immediately
set -o notify

# No mail notification
unset MAILCHECK

# Reset default keybind
bindkey -d

# auto cd
setopt AUTO_CD

# ls等での日本語文字化け対策
export LANG=C
export LC_CTYPE=ja_JP.UTF-8

#---------------------------------------------------------------------------------
# Environment Configuration
#---------------------------------------------------------------------------------

# detect interactive shell
case "$-" in
  *i*) INTERACTIVE=yes ;;
  *) unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
  -*) LOGIN=yes ;;
  *) unset LOGIN ;;
esac

#---------------------------------------------------------------------------------
# Editor and Pager
#---------------------------------------------------------------------------------
EDITOR="vim"
export EDITOR

PAGER="less -g -i -M -R -S -W -z-4 -x4 -j20"
MANPAGER="$PAGER"
export PAGER MANPAGER

# Colors for less pager
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_so=$'\E[1;91m'        # begin standout-mode - info box
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#---------------------------------------------------------------------------------
# Prompt
#---------------------------------------------------------------------------------

# get git status
autoload -Uz vcs_info
setopt prompt_subst  # PROMPT変数内で変数参照

# git
# %b: branch name, %a: action name (ex. merge), %c: changes, %u: uncommit
zstyle ':vcs_info:git:*' check-for-changes true                 # enable to use %c, %u
zstyle ':vcs_info:git:*' stagedstr         "%F{green}!"         # there are non commit files
zstyle ':vcs_info:git:*' unstagedstr       "%F{magenta}+"       # there are non add files
zstyle ':vcs_info:*'     formats           "%F{cyan}%c%u(%b)%f" # normal
zstyle ':vcs_info:*'     actionformats     '[%bl%a]'            # rebase or something

function prompt_git() {
  # ${fg[cyan]}%....$reset_color : set prompt color
  PROMPT='${vcs_info_msg_0_} $ '
  RPROMPT='%{${fg[cyan]}%}[%~]%{${reset_color}%}'
}

precmd(){vcs_info}
prompt_git

#---------------------------------------------------------------------------------
# Aliases
#---------------------------------------------------------------------------------

# Docker aliases
alias d='docker'
alias dp='docker-compose'
alias dcp='yes | docker container prune'

# Git aliases
alias gp='git push origin HEAD'
alias ch='git checkout'
alias gb='git branch'
alias gl='git pull'

# Others
alias l='ls -GF'
alias ls='ls -GF'
alias ll='ls -laF'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias t='tig'
alias rust="evcxr"
alias k="kubectl"

# config files
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.config/nvim/init.vim"
alias dein="vim ~/.config/nvim/dein.toml"
alias deinl="vim ~/.config/nvim/dein_lazy.toml"
alias tmuxconf="vim ~/.tmux.conf"

alias sz="source ~/.zshrc"

alias vimconf="cd ~/.config/nvim/"

alias m="make"

if [[ "$(uname)" == "Darwin" ]]; then
  alias md="open -a typora"
fi

# 'r' コマンドを使用しない
disable r

if [[ -n $VIMRUNTIME ]]; then
  alias vim='nvr'
  alias vi='nvr'
  alias v='nvr'
fi

#---------------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------------

# dke は端末設定を行いながら docker コンテナへログインする
function dke() {
  docker exec -it -e COLUMNS=$COLUMNS -e LINES=$LINES -e TERM=$TERM $@ bash
}

# ra は git のブランチ変更を fzr でインタラクティブに行う
function ra() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# ras はリモートブランチを含めて git のブランチ変更を fzr でインタラクティブに行う
function ras() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# grap はファイル内検索とエディタの起動を行う
function grap() {
  local result=$(rg --line-number "$@" | fzf --delimiter=: --preview 'bat --color=always --highlight-line {2} {1} 2>/dev/null || head -n $(({2}+10)) {1} | tail -n 20')
  if [ -n "$result" ]; then
    local filepath=$(echo "$result" | awk -F: '{print $1}')
    local line=$(echo "$result" | awk -F: '{print $2}')
    vim "$filepath" "+$line"
  fi
}

# dps は docker ps の省略テンプレートを表示する
function dps() {
  echo "cont_id        status        name                          image"
  docker ps --format "{{.ID}}   {{.Status}}   {{.Names}}   {{.Image}}"
}

# rust_rn は Rust の単一ファイルをコンパイル & 実行する
function rust_run() {
    rustc $1
    local binary=$(basename $1 .rs)
    ./$binary
}

#---------------------------------------------------------------------------------
# Key mapping
#---------------------------------------------------------------------------------

# bindkey -v
bindkey -M viins '^A'  beginning-of-line
# bindkey -M viins '^E'  end-of-line
# bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
# bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line

#---------------------------------------------------------------------------------
# Plugins
#---------------------------------------------------------------------------------

# " ctrl + ] " starts incremental repo search
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# " ctrl + r " starts history incremental search
setopt hist_ignore_all_dups

function peco_select_history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco_select_history
bindkey '^r' peco_select_history

#-------------------------------------------------------------------------------
# User Shell Environment
#-------------------------------------------------------------------------------

# read local settings
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# Zsh autoload
# 独自 autoload を格納する場所
export FPATH="$HOME/.zsh/autoload/:$FPATH"

# Zsh 補完
autoload -U compinit
compinit

# git, peco などの設定ファイル
export XDG_CONFIG_HOME=$HOME/.config

# Rust
export LD_LIBRARY_PATH=$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib
# PATH 更新系の設定
if [[ -z $ZSHRC_PATH_UPDATED ]]; then
  # Go
  # export GOPATH=$HOME/go
  # export GOENV_ROOT="$HOME/.goenv"
  # export PATH="$GOENV_ROOT/bin:$PATH"
  # eval "$(goenv init -)"
  # export PATH="$GOROOT/bin:$PATH"
  # export PATH="$GOPATH/bin:$PATH"

  # python
  # export LD_LIBRARY_PATH=/usr/local/lib
  export PYTHONDONTWRITEBYTECODE=1 # pycache作成しない

  # Node
  export PATH=$HOME/.nodebrew/current/bin:$PATH

  export PATH="$PATH:$HOME/.cargo/bin"

  export PATH="$PATH:$HOME/flutter/bin"

  # Java (detect platform)
  if [ -d "/Library/Java/JavaVirtualMachines" ]; then
    # macOS
    local java_dir=$(ls -d /Library/Java/JavaVirtualMachines/*/Contents/Home 2>/dev/null | head -1)
    if [ -n "$java_dir" ]; then
      export JAVA_HOME="$java_dir"
      export PATH="$PATH:$JAVA_HOME/bin"
    fi
  elif [ -n "$JAVA_HOME" ]; then
    export PATH="$PATH:$JAVA_HOME/bin"
  fi

  export ZSHRC_PATH_UPDATED=1
fi

# ls command colors
LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS

if [ -f ~/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors ~/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors ~/.dircolors)
    fi
fi

# fzf
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --prompt="P " --header="H" --margin=1,3 --inline-info'

export ZDOTDIR=$HOME

# 端末固有の設定ファイル
if [ -f ~/.zsh.local ]; then
  source ~/.zsh.local
fi

# export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"

if command -v nodenv &>/dev/null; then
  eval "$(nodenv init -)"
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# kube-ps1
local kube_ps1_path="/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
if [ -f "$kube_ps1_path" ]; then
  source "$kube_ps1_path"
  PROMPT='$(kube_ps1)'$PROMPT
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# SSH agent (reuse existing agent if available)
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add ~/.ssh/gitlab 2>/dev/null
fi

# .NET 環境設定
export DOTNET_ROOT=/usr/local/share/dotnet
export PATH=$DOTNET_ROOT:$PATH

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"
