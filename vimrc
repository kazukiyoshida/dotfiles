scriptencoding utf-8
set encoding=utf8

"----------------------------------------------------------------------
" Basic Options
"----------------------------------------------------------------------
set autoread              " 外部で変更されたファイルがあれば自動で読み込みする
set backspace=2           " Makes backspace not behave all retarded-like
set hidden                " ファイルが未保存状態でも別ファイルを開ける
set laststatus=2          " Always show the status bar
set list                  " タブ、空白、改行の可視化
set listchars=tab:>>,trail:_,extends:>,precedes:< " eol:↲  tab:>.,
set number                " 行番号を表示
set ruler                 " Show the line number and column in the status bar
set t_Co=256              " Use 256 colors
set showmatch             " ステータスラインを常に表示
set showmode              " Show the current mode on the open buffer
set title                 " ターミナルのタイトルをセットする
set smartindent           " 改行時に自動的にインデントを増減する
set virtualedit=onemore   " 行末の1文字先までカーソルを移動できるようにする
set nowrap                " 長い行を折り返ししない
set shell=$SHELL          " shell を設定

" Backup settings
set nobackup               " バックアップファイル.swpを作成しない
set noswapfile             " 編集中にスワップファイルを作らない

" Search settings
set hlsearch               " 検索結果をハイライト
set ignorecase             " 検索に大文字小文字を区別しない
set smartcase              " 検索に大文字を含んでいたら大文字小文字を区別する
set incsearch              " インクリメンタルサーチ. 1文字入力毎に検索を実行

" Tab settings
set expandtab              " タブ入力を複数の空白入力に置き換える
set tabstop=2              " 画面上でタブ文字が占める幅
set softtabstop=2          " 連続した空白でTabやBackspaceが適切に動く
set shiftwidth=2           " smartindentで増減する幅

" Other settings

" Highlight 80 character limit
let &colorcolumn=join(range(81,999),",")
hi ColorColumn ctermbg=235 guibg=#2c2d27

" tmux のペイン間Vimで yank & paste を可能にする
set clipboard+=unnamed

" 全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

" 特殊記号は目立たなくする
highlight SpecialKey ctermfg=18

filetype plugin indent on

"----------------------------------------------------------------------
" Key Mappings
"----------------------------------------------------------------------
inoremap jk <esc>

" Fix paste bug triggered by the above inoremaps
set t_BE=

nnoremap <silent><C-e> :NERDTreeToggle<CR>

nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>

"----------------------------------------------------------------------
" Autocommands
"----------------------------------------------------------------------
" Clear whitespace at the end of lines automatically
autocmd BufWritePre * :%s/\s\+$//ge

" Don't fold anything
autocmd BufWinEnter * set foldlevel=999999

" Select file type
autocmd BufNewFile,BufRead *.{html,htm,vue*} set filetype=html

"----------------------------------------------------------------------
" Dein settings
"----------------------------------------------------------------------

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.config/nvim')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  let g:go_bin_path = $GOPATH.'/bin'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

syntax on


let mapleader = ","
nmap s <Plug>(easymotion-s)
