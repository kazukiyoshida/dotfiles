#!/bin/zsh

echo '---- zshrc ----'

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

PAGER="less -g -i -M -R -S -W -z-4 -x4"
MANPAGER="$PAGER"
export PAGER MANPAGER

#Colors for less pager (man pages)
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
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
alias dip='yes | docker container prune'

# Git aliases
alias gp='git push origin HEAD'
alias ch='git checkout'
alias gb='git branch'

# Others
alias hi='history | tail -20'
alias l='ls -GF'
alias ls='ls -GF'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias t='tig'
alias tm='tmux'
alias rr="rust_run"
alias j="just"
alias m="make"
alias rust="evcxr"
alias k="kubectl"
alias ll='ls -laF'

# config files
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.config/nvim/init.vim"
alias dein="vim ~/.config/nvim/dein.toml"
alias deinl="vim ~/.config/nvim/dein_lazy.toml"

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
  file_and_line=$(ag $* | peco | awk -F: '{printf $1 ":" $2}')
  filepath=$( echo $file_and_line | awk -F: '{printf $1}' )
  lines=$( echo $file_and_line | awk -F: '{printf $2}' )
  if [ -n "$filepath" ]; then
    vim $filepath "+"$lines
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
# bindkey -M viins '^D'  delete-char-or-list
# bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line

#---------------------------------------------------------------------------------
# Plugins
#---------------------------------------------------------------------------------

# Peco
function find_cd() {
  cd "$(find . -type d | peco)"
}

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
export RLS_ROOT=/Users/kazukiyoshida/code/src/github.com/rust-lang-nursery/rls/target/release/rls

# PATH 更新系の設定
if [[ -z $ZSHRC_PATH_UPDATED ]]; then
  # Go
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
  # export PATH="$GOROOT/bin:$PATH"
  export PATH="$GOPATH/bin:$PATH"

  # python
  # export LD_LIBRARY_PATH=/usr/local/lib
  export PYTHONDONTWRITEBYTECODE=1 # pycache作成しない
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"

  # Node
  export NODEBREW_HOME=/usr/local/var/nodebrew/current
  export NODEBREW_ROOT=/usr/local/var/nodebrew
  export PATH="$HOME/.nodenv/shims:$PATH"

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
