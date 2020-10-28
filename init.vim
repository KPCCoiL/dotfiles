scriptencoding utf-8

" dein {{{
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let s:strict_toml = '~/.config/nvim/dein.toml'
let s:lazy_toml = '~/.config/nvim/dein_lazy.toml'

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein', [$MYVIMRC, s:strict_toml, s:lazy_toml])

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif


filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

function! s:edit_conf()
  edit $MYVIMRC
  exec 'tabedit ' . s:strict_toml
  exec 'tabedit ' . s:lazy_toml
endfunction

command! EditConf call s:edit_conf()
" }}}

" editing {{{
set number
set foldmethod=marker
set ignorecase
set smartcase
set inccommand=split
set splitright
" }}}

" indentation {{{
set expandtab
set softtabstop=2
set shiftwidth=2
set list
set listchars=tab:TAB,trail:␣,nbsp:├
function s:cpp_indent()
  setlocal cindent
  setlocal cino=j1
endfunction
augroup CppIndent
  autocmd!
  autocmd FileType c,cpp call s:cpp_indent()
augroup END
" }}}

" global keymaps {{{
inoremap <C-l> <Esc>
vnoremap <C-l> <Esc>
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap <silent> j gj
vnoremap <silent> j gj
nnoremap <silent> k gk
vnoremap <silent> k gk
nnoremap <silent> Y y$
" }}}

" miscallaneous {{{
set backupdir=~/.nvim-backup
set undofile
set undodir=~/.nvim-undo
set mouse=a
" }}}

" terminal (repl) {{{
function! s:open_repl()
  let repl_cmd = {
        \ 'c': 'cling -std=c11',
        \ 'cpp': 'cling -std=c++17',
        \ 'python': 'python3',
        \ 'rust': 'evcxr',
        \ 'haskell': 'ghci',
        \ 'idris': 'idris -p contrib -p pruviloj',
        \ 'ocaml': 'ocaml',
        \ 'coq': 'coqtop',
        \ 'javascript': 'node',
        \ 'typescript': 'npx ts-node',
        \ 'bash': 'bash',
        \ }
  if has_key(repl_cmd, &filetype)
    vsplit
    execute 'terminal ' . repl_cmd[&filetype]
  endif
endfunction

tnoremap <C-n><C-l> <C-\><C-n>
nnoremap <M-S-CR> :<C-u>tabnew \| terminal<CR>
nnoremap <Space>\| :<C-u>call <SID>open_repl()<CR>
" }}}

" competitive programming {{{
function! s:insert_template()
  let template_dir = expand('~/competitive-templates')
  if finddir(template_dir) == ''
    echomsg 'template dir not found'
    return
  endif
  let template = template_dir . '/template.' . &filetype
  if findfile(template) == ''
    echomsg 'template file not found'
    return
  endif
  let contents = join(readfile(template), "\n")
  put! = contents
  cd %:h
  let language = {
    \ 'cpp': '4004',
    \ 'python': '4047',
    \ 'perl6': '4043',
    \ 'haskell': '4027'
    \ }
  nnoremap <buffer> <Space>t :<C-u>Build test<CR>
  execute 'command! Submit tabnew term://' . expand('%:h') . '//oj submit -l ' . language[&filetype] . ' ' . expand('%')
endfunction

command! PutTemplate call s:insert_template()
" }}}
