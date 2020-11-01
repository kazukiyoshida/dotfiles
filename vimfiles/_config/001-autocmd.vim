"----------------------------------------------------------------------
" Autocommands
"----------------------------------------------------------------------
" Clear whitespace at the end of lines automatically
autocmd BufWritePre * :%s/\s\+$//ge

" Don't fold anything
autocmd BufWinEnter * set foldlevel=999999

" Select file type
autocmd BufNewFile,BufRead *.{html,htm,vue*} set filetype=html
