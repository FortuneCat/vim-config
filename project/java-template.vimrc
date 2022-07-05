
" java project-specific settings
" place all settings in the .vimrc file at top directory of your project

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Compile function {
noremap r <CMD>call CompileRun()<CR>
func! CompileRun()
  exec "w"
  if &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'java'
    term javac % && time java %<
  endif
endfunc
"} // Compile function

set includeexpr=substitute(v:fname,'\\.','/','g')
let &path.="src/include,/usr/include,"

" auto-pairs
au FileType java let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"'}

