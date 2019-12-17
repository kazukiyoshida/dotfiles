#!/bin/zsh

# Return if current zsh is called from vim
if [[ -n $VIMRUNTIME ]]; then
    return 0
fi

#---------------------------------------------------------------------------------
# Shell Options
#---------------------------------------------------------------------------------

# Default file permissions
umask 022

# No coredump file
limit coredumpsize 0

# Notify background task completion immediately
set -o notify

# No mail notification
unset MAILCHECK

# Set default keybind
bindkey -d

# auto cd
setopt AUTO_CD

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
  PROMPT='${vcs_info_msg_0_}`command_status_emoji $?` '
  RPROMPT='%{${fg[cyan]}%}[%~]%{${reset_color}%}'
}

function command_status_emoji() {
  local symbol=🙅
  if [ $1 = 0 ];then
    symbol=🙆
  elif [ $1 = 130 ];then
    symbol=😍
  fi
  echo ${symbol}
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
alias ti='tig'
alias rr="rust_run"
alias j="just"

# 'r' コマンドを使用しない
disable r

#---------------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------------

# command_not_found_handler はコマンドが正常終了しなかった場合に絵文字を返却する
function command_not_found_handler() {
  echo "🙈 Oops!"
  return 1
}

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

bindkey -v
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^H'  backward-delete-char
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

#-------------------------------------------------------------------------------
# GCloud Settings
#-------------------------------------------------------------------------------

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kazukiyoshida/google-cloud-sdk/path.zsh.inc' ]; then
  . '/Users/kazukiyoshida/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kazukiyoshida/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/Users/kazukiyoshida/google-cloud-sdk/completion.zsh.inc'
fi
