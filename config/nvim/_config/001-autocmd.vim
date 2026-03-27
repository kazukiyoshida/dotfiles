"----------------------------------------------------------------------
" Autocommands
"----------------------------------------------------------------------
" Clear whitespace at the end of lines automatically
" autocmd BufWritePre * :%s/\s\+$//ge

" Don't fold anything
autocmd BufWinEnter * set foldlevel=999999

" Select file type
autocmd BufNewFile,BufRead *.{html,htm,vue*} set filetype=html

" terraform ファイルでは LSP を無効化する
autocmd FileType terraform autocmd BufWinEnter <buffer> call timer_start(100, {-> execute('LspStop')})

" 保存時にフォーマット (terraform は除外)
autocmd BufWritePost * if &filetype != 'terraform' | execute('LspDocumentFormat') | endif
