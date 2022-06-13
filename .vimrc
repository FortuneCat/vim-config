
" An ultimate .vimrc for C++ developers
" Author: yingly

" Automatically install plug.vim if not available
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Editor setup {
" System
set clipboard=unnamedplus
let &t_ut=''

set nocompatible
" filetype on
" filetype indent on
" filetype plugin on
" filetype plugin indent on

set cursorline

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround

set splitright
set splitbelow

set list
set listchars=tab:\|\ ,trail:·

set scrolloff=8
set indentexpr=
set backspace=indent,eol,start

set foldenable
set foldlevel=99
set foldmethod=indent

syntax on
set number
set norelativenumber
set cursorline

set wrap
set tw=0

set showcmd
set wildmenu

set hlsearch
" Cancle highlight if exited
exec "nohlsearch"
set incsearch

set ignorecase
set smartcase

set encoding=utf-8
set laststatus=2

if has('gui_running')
  if has("win16") || has("win32") || has("win95") || has("win64")
    set guifont=Consolas:h11,Courier_New:h11:cANSI
  else
    set guifont=MiscFixed\ Semi-Condensed\ 10
  endif
endif

" } // Editor setup

" Auto commands {
" Change cursor styles
if has("autocmd")
  autocmd VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  autocmd InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[6 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[4 q"' | redraw! |
    \ endif
  autocmd VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

" Keep cursor location
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" } // Auto commands

" Key mappings {
" Set Leader as ,
let mapleader = ","

" Map <CMD> as ;
noremap ; :

" Save & quit
noremap S :w<CR>
noremap Q :q<CR>
noremap <C-c> ZQ<CR> 

" Quick access to .vimrc
noremap V <CMD>e $MYVIMRC<CR>
noremap R <CMD>source $MYVIMRC<CR>

" Find next duplicate words
noremap <LEADER>D /\(\<\w\+\>\)\_s*\1

" Copy till the end of line
nnoremap Y y$

" Copy to system clipboard
vnoremap Y "+y

" Indentation
nnoremap < <<
nnoremap > >>

" Tab to spaces
nnoremap <LEADER>ts :%s/\t/  /g
vnoremap <LEADER>ts :s/\t/  /g

" Delete pairs
nnoremap dp d%

" Search
noremap = nzz
noremap - Nzz

" Relative line number
noremap +r <CMD>set relativenumber<CR>
noremap -r <CMD>set norelativenumber<CR>

" No/cance hignlight in search
noremap +h <CMD>set hlsearch<CR>
noremap -h <CMD>nohlsearch<CR>

" (un)Highlight column
noremap +c <CMD>set cursorcolumn<CR>
noremap -c <CMD>set nocursorcolumn<CR>

" Disable BS
nnoremap <BS> <CMD>echo "Backspace disabled"<CR>

" Folding
noremap <silent> <LEADER>o za

" Find and replace
noremap \s :%s//g<left><left>

" Faster navigation
noremap <silent> e v$h
noremap <silent> <LEADER>j 5j
noremap <silent> <LEADER>k 5k
noremap <silent> W 5w
noremap <silent> B 5b
noremap <silent> S 0
noremap <silent> E $

" Switch between last two files
nnoremap <LEADER><LEADER> <C-^>

"" Window {
" Split screen to up, down, left and right
noremap sj :set splitbelow<CR>:split<CR>
noremap sk :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap sl :set splitright<CR>:vsplit<CR>

" Place the first window to upper-side above others
noremap sh <C-w>t<C-w>K

" Place windows side by side
" noremap sv <C-w>t<C-w>H

" Rotate screens
noremap shr <C-w>b<C-w>K
noremap svr <C-w>b<C-w>H

" Resize splits with arrow keys
nnoremap <Left> :vertical res -5<CR>
nnoremap <Right> :vertical res +5<CR>
nnoremap <Up> :res +5<CR>
nnoremap <Down> :res -5<CR>

" Window cursor movement
nnoremap <LEADER>j <C-w>j
nnoremap <LEADER>k <C-w>k
nnoremap <LEADER>h <C-w>h
nnoremap <LEADER>l <C-w>l
nnoremap <LEADER>w <C-w>w
nnoremap <LEADER>o <C-w>o
"" } // Window

"" Tab {
noremap te <CMD>tabe<CR>
noremap ts <CMD>tab split<CR>
noremap tc <CMD>tabc<CR>
noremap tp <CMD>tabp<CR>
noremap tn <CMD>tabn<CR>
noremap Tp <CMD>-tabmove<CR>
noremap Tn <CMD>+tabmove<CR>
"" } // Tab

" } // Key mappings

" Compile function {
noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  if &filetype == 'c'
    exec "!g++ % -o %<"
    exec "!time ./%<"
  elseif &filetype == 'cpp'
    set splitbelow
    exec "!g++ -std=c++11 -lpthread % -Wall -o %<"
    " :sp
    " :res -15
    :term ./%<
  elseif &filetype == 'cs'
    set splitbelow
    silent! exec "!mcs %"
    :sp
    :res -5
    :term mono %<.exe
  elseif &filetype == 'java'
    set splitbelow
    :sp
    :res -5
    term javac % && time java %<
  elseif &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'python'
    set splitbelow
    :sp
    :term python3 %
  elseif &filetype == 'html'
    silent! exec "!".g:mkdp_browser." % &"
  elseif &filetype == 'markdown'
    exec "InstantMarkdownPreview"
  elseif &filetype == 'tex'
    silent! exec "VimtexStop"
    silent! exec "VimtexCompile"
  elseif &filetype == 'dart'
    exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
    silent! exec "CocCommand flutter.dev.openDevLog"
  elseif &filetype == 'javascript'
    set splitbelow
    :sp
    :term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
  elseif &filetype == 'go'
    set splitbelow
    :sp
    :term go run .
  endif
endfunc
"} // Compile function

" Plugins installed with vim-plug {
let g:plug_url_format = 'git@github.com:%s.git' " ssh

call plug#begin('~/.vim/bundle')

" Editor enhancement {
Plug 'junegunn/vim-peekaboo'
" }


Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'connorholyday/vim-snazzy'

" Auto complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" File navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'

" Snippets
Plug 'honza/vim-snippets'

" Taglist
Plug 'liuchengxu/vista.vim'

" Undo tree
Plug 'mbbill/undotree'

" Editor enhancement
Plug 'jiangmiao/auto-pairs'
Plug 'tomtom/tcomment_vim', {'branch': 'release'}

Plug 'ryanoasis/vim-devicons'

call plug#end()
" } // Plugins

" Plugin settings  {

" vim-airline {
let g:airline_theme="luna"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 1

nnoremap [b <CMD>bp<CR>
nnoremap ]b <CMD>bn<CR>

map <LEADER>1 <CMD>b 1<CR>
map <LEADER>2 <CMD>b 2<CR>
map <LEADER>3 <CMD>b 3<CR>
map <LEADER>4 <CMD>b 4<CR>
map <LEADER>5 <CMD>b 5<CR>
map <LEADER>6 <CMD>b 6<CR>
map <LEADER>7 <CMD>b 7<CR>
map <LEADER>8 <CMD>b 8<CR>
map <LEADER>9 <CMD>b 9<CR>

"} // vim-airline

" coc.nvim {
let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-explorer',
  \ 'coc-json',
  \ 'coc-snippets',
  \ 'coc-vimlsp',
  \ 'coc-yank']

"" coc-explorer {
let g:coc_explorer_global_presets = {
  \ '.vim': {
  \   'root-uri': '~/.vim',
  \ },
  \ 'tab': {
  \   'position': 'tab',
  \   'quit-on-open': v:true,
  \ },
  \ 'floating': {
  \   'position': 'floating',
  \   'open-action-strategy': 'sourceWindow',
  \ },
  \ 'floatingTop': {
  \   'position': 'floating',
  \   'floating-position': 'center-top',
  \   'open-action-strategy': 'sourceWindow',
  \ },
  \ 'floatingLeftside': {
  \   'position': 'floating',
  \   'floating-position': 'left-center',
  \   'floating-width': 50,
  \   'open-action-strategy': 'sourceWindow',
  \ },
  \ 'floatingRightside': {
  \   'position': 'floating',
  \   'floating-position': 'right-center',
  \   'floating-width': 50,
  \   'open-action-strategy': 'sourceWindow',
  \ },
  \ 'simplify': {
  \   'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
  \ }
  \ }

nmap <space><space> <CMD>CocCommand explorer<CR>
nmap <space>f <CMD>CocCommand explorer --preset floating<CR>

" Automatically open a coc explorer if no files specified
autocmd VimEnter * if !argc() | CocCommand explorer | endif

" Close vim if the only window left open
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
"" } // coc-explorer

nmap sn <CMD>CocCommand snippets.editSnippets<CR>

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'


" " Use tab for trigger completion with characters ahead and navigate.
" " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-o> to trigger completion.
inoremap <silent><expr> <c-o> coc#refresh()

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> H :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

function! s:CocActionsOpenFromSelected(type) abort
  execute 'CocComand actions.open' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

" coc-snippets
imap <Tab> <Plug>(coc-snippets-expand)
vmap <C-e> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<c-e>'
let g:coc_snippet_prev = '<c-n>'
imap <C-e> <Plug>(coc-snippets-expand-jump)
let g:snips_author = 'David Chen'
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc

" coc-yank
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<CR>

" } // coc.nvim

" coc

" fzf.vim {
" nnoremap <c-p> :LEADERf file<CR>
noremap <silent> <LEADER>f :Files<CR>
noremap <silent> <LEADER>b :Buffers<CR>
noremap <silent> <LEADER>p :Lines<CR>
noremap <silent> <LEADER>hh :History<CR>
noremap <silent> <C-f> :Rg<CR>
"noremap <C-t> :BTags<CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8  }  }
let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines)  },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
  \ }))
noremap <c-d> :BD<CR>

" } // fzf.vim

" vista.vim {
noremap <LEADER>v :Vista!!<CR>
noremap <c-t> :silent! Vista finder coc<CR>

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
  \   "function": "\uf794",
  \   "variable": "\uf71b",
  \}

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" } // vista.vim

" undotree {
noremap U :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
function g:Undotree_CustomMap()
  nmap <buffer> k <plug>UndotreeNextState
  nmap <buffer> j <plug>UndotreePreviousState
  nmap <buffer> K 5<plug>UndotreeNextState
  nmap <buffer> J 5<plug>UndotreePreviousState
endfunc
" } // undotree

" color schema
color snazzy
let g:SnazzyTransparent = 1

" auto-pairs
au FileType c,cpp let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"'}
au FileType py let b:AutoPairs = {"`":"`", '```':'```', '"""':'"""', "'''":"'''"}

" tcomment_vim
nnoremap ci cl
let g:tcomment_textobject_inlinecomment = ''
nmap <LEADER>cn g>c
vmap <LEADER>cn g>
nmap <LEADER>cu g<c
vmap <LEADER>cu g<

" } // Plugin settings
