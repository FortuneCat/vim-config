" Folding

set foldenable
set foldlevel=99
set foldmethod=indent

" make views automatic
source $VIMPATH/fold/restore_view.vim

noremap <silent> <LEADER>fi <CMD>set fdm=indent<CR>
noremap <silent> <LEADER>fk <CMD>set fdm=marker<CR>
noremap <silent> <LEADER>fm <CMD>set fdm=manual<CR>

autocmd FileType vim setlocal foldmethod=marker

