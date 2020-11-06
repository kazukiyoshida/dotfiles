"----------------------------------------------------------------------
" Key Mappings
"----------------------------------------------------------------------
" cf. vimでキーマッピングする際に考えたほうがいいこと
" http://deris.hatenablog.jp/entry/2013/05/02/192415

nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>

" Neovim の :terminal でも水平・上下分割で開けるようにする
" cf. https://github.com/neovim/neovim/issues/5073
if has('nvim')
  command! -nargs=* Term rightbelow new | set nonumber | terminal <args>
  command! -nargs=* Termv vsplit | terminal <args>
endif

" Insert mode から Normal mode へ
inoremap jk <esc>

" Terminal-job mode から Normal mode へ
tnoremap <Esc> <C-\><C-n>
" Fix paste bug triggered by the above inoremaps
set t_BE=

" カーソル下の単語を0番レジスタのデータで置換する
nnoremap <C-j> viwc<C-r>0<ESC>

" 検索・ジャンプ時にカーソルを中央に持ってくる
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap <C-o> <C-o>zz

" mapleader を変更
let mapleader = ","

" easy motion
" TODO ここに記述するべきではないかも
nmap s <Plug>(easymotion-s)

nnoremap m, :Files<CR>
nnoremap mk :Rg<CR>
nnoremap ml :Term<CR>
