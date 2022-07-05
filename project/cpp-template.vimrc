
" cpp project-specific settings
" place all settings in the .vimrc file at top directory of your project

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Compile function {
noremap r <CMD>call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  if &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'c'
    exec "!g++ % -o %<"
    exec "!time ./%<"
  elseif &filetype == 'cpp'
    exec "!g++ -std=c++11 -lpthread % -Wall -o %<"
    :term ./%<
  endif
endfunc
"} // Compile function

augroup project
  autocmd!
  autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

let &path.="src/include,/usr/include,"

" auto-pairs
au FileType c,cpp let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"'}

