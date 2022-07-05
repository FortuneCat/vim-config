
" python project-specific settings
" place all settings in the .vimrc file at top directory of your project

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Compile function {
noremap r :call CompileRun()<CR>
func! CompileRun()
  exec "w"
  if &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'python'
    :term python3 %
  endif
endfunc
"} // Compile function

" auto-pairs
au FileType py let b:AutoPairs = {"`":"`", '```':'```', '"""':'"""', "'''":"'''"}

