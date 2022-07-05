
" web project-specific settings
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
  elseif &filetype == 'html'
    silent! exec "!".g:mkdp_browser." % &"
  elseif &filetype == 'markdown'
   exec "InstantMarkdownPreview"
  elseif &filetype == 'javascript'
    :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
  endif
endfunc
"} // Compile function

" auto-pairs
au FileType html let b:AutoPairs = {'<':'>'}

