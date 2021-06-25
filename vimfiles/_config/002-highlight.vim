"----------------------------------------------------------------------
" Highlight
"----------------------------------------------------------------------

" Highlight 80 character limit
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27

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

" https://github.com/w0ng/vim-hybrid
" download vimfile to ~/.vim/colors/hybrid.vim
colorscheme hybrid
