"----------------------------------------------------------------------
" Key Mappings
"----------------------------------------------------------------------
" cf. vimでキーマッピングする際に考えたほうがいいこと
" http://deris.hatenablog.jp/entry/2013/05/02/192415

" Esc 系
nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
inoremap jk <ESC>
tnoremap <Esc> <C-\><C-n>

" 移動後はカーソルを中央に揃える
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap <C-o> <C-o>zz

nnoremap <C-t><C-t> :Term<CR>
nnoremap <C-s><C-s> :sp<CR>
nnoremap <C-v><C-v> :vsp<CR>
nnoremap <C-p> viwc<C-r>0<ESC>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" nnoremap <C-]> :bn<CR>

" *** easy motion -> S Key
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-s2)

" *** LSP -> Space Key
let mapleader = "\<Space>"
nnoremap <Leader>ho :LspHover<CR>
nnoremap <Leader>df :LspDefinition<CR>
nnoremap <Leader>ty :LspTypeDefinition<CR>
nnoremap <Leader>er :LspNextError<CR>
nnoremap <Leader>eb :LspPreviousError<CR>
nnoremap <Leader>rr :LspReferences<CR>
nnoremap <Leader>re :LspRename<CR>
" <Leader> LspDocumentDiagnostics : 保存時に毎回実行したい
" <Leader> LspDocumentFormat : 保存時に毎回実行

" *** fzf -> M Key
nnoremap mk :Files<CR>
nnoremap ml :Rg<CR>
nnoremap mf :Buffers<CR>
nnoremap ms :Snippets<CR>

" *** Others
" vim window resize
" comment out
" snipet

" Neovim の :terminal でも水平・上下分割で開けるようにする
" cf. https://github.com/neovim/neovim/issues/5073
if has('nvim')
  command! -nargs=* Term rightbelow new | set nonumber | terminal <args>
  command! -nargs=* Termv vsplit | terminal <args>
endif


nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=30<CR>

" sample
nnoremap <silent> <leader>t :call sample#helloWorld()<cr>
nnoremap <silent> <leader>s :call utils#sourceVimrc()<cr>
