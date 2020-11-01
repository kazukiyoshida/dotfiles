"----------------------------------------------------------------------
" Key Mappings
"----------------------------------------------------------------------
inoremap jk <esc>

" Fix paste bug triggered by the above inoremaps
set t_BE=

nnoremap <silent><C-e> :NERDTreeToggle<CR>

nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>
