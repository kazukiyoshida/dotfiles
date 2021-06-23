### Zsh の設定ファイルがよばれるパターン

- terminal を開く         -> zshenv, zprofile, zshrc, zlogin
- tmux を開く             -> zshenv, zprofile, zshrc, zlogin
- tmux でペインを分割する -> zshenv, zprofile, zshrc, zlogin
    * ここで 2回 zshrc が呼ばれるため、ZSHRC_PATH_UPDATED フラグで管理する必要がある
- vim から :term          -> zshenv, zshrc

### vim script から Ex command を実行する

execute 'echo' '"godzilla"'
cf. https://knowledge.sakura.ad.jp/23436/


### Plugin でエラーが発生した場合

install されているはずなのに読み込まれない
-> ~/.cache/dein/repo を削除してもう一度 install してみる


### :set runtimepath? で vim 用のディレクトリを確認しておく

ちょっと多すぎる気もする..
runtimepath=
  ~/.cache/dein/repos/github.com/Shougo/dein.vim/
  ~/.config/nvim
  /etc/xdg/nvim
  ~/.local/sh
  are/nvim/site
  /usr/local/share/nvim/site
  /usr/share/nvim/site
  ~/.cache/dein/repos/github.com/junegunn/
  fzf
  ~/.cache/dein/repos/github.com/Shougo/dein.vim
  ~/.cache/dein/repos/github.com/tpope/vim-surround
  ~
  /.cache/dein/repos/github.com/cohama/lexima.vim
  ~/.cache/dein/repos/github.com/mattn/emmet-vim
  ~/.cach
  e/dein/.cache/init.vim/.dein
  /opt/homebrew/Cellar/neovim/0.4.4_2/share/nvim/runtime
  /opt/homebrew/Cell
  ar/neovim/0.4.4_2/share/nvim/runtime/pack/dist/opt/matchit
  ~/.cache/dein/.cache/init.vim/.dein/after
  /
  usr/share/nvim/site/after
  /usr/local/share/nvim/site/after
  ~/.local/share/nvim/site/after
  /etc/xdg/nvi
  m/after
  ~/.config/nvim/after
  /usr/local/opt/fzf


### 自分で割り当てたキーマップの確認

:map KEY            " 全て確認する
:verbose nmap KEY   " 定義元ファイル情報も表示する


### ペーストによって時々発生する ^[200~ エラーについて

bracketed paste で何か問題がある場合、.vimrc に以下を書くことで無効化することができる.
set t_BE=
cf. https://vim-jp.org/vimdoc-ja/term.html


### Filer: Fern.vim

- j, k: up, down
- l   : open folder, file
- h   : close folder
- e   : open file
- E   : open file with V Split

- N : create new file
- K : create new directory
- D : delete directory
- R : rename file

- y : ファイルパスをコピーする


- 一文字だけ変更したい時はその文字の上で `r` を押して好きな文字を入力.
- `ea` で現在の文字の最後でインサートモードが始まる
