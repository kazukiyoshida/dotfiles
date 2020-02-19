
export EDITOR=vim
export XDG_CONFIG_HOME=$HOME/.config

# ls等での日本語文字化け対策
export LANG=C
export LC_CTYPE=ja_JP.UTF-8

# python
export PYENV_ROOT="${HOME}/.pyenv"
export LD_LIBRARY_PATH=/usr/local/lib
export PYTHONDONTWRITEBYTECODE=1 # pycache作成しない

# Node
export NODEBREW_HOME=/usr/local/var/nodebrew/current
export NODEBREW_ROOT=/usr/local/var/nodebrew

# Go
export GOPATH=$HOME/code
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on

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

