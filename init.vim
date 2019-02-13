"  ,--.        ,--.  ,--.            ,--.           
" `--',--,--, `--',-'  '-.,--.  ,--.`--',--,--,--. 
" ,--.|      \,--.'-.  .-' \  `'  / ,--.|        | 
" |  ||  ||  ||  |  |  |.--.\    /  |  ||  |  |  | 
" `--'`--''--'`--'  `--''--' `--'   `--'`--`--`--' 

" dein.vim {{{
if &compatible
	set nocompatible
endif

let s:dein_location = expand("~/.cache/dein")
let s:dein_plugin_path = s:dein_location . "/repos/github.com/Shougo/dein.vim"
execute 'set runtimepath+=' . s:dein_plugin_path

if dein#load_state(s:dein_location)
  call dein#begin(s:dein_location)
  call dein#add(s:dein_plugin_path)
  call dein#add("idris-hackers/idris-vim", {'on_ft' : 'idris'})
  call dein#add("clojure-vim/acid.nvim")
  call dein#add("l04m33/vlime", {'rtp' : 'vim/'})
  call dein#add("dag/vim-fish")
  call dein#add("Shougo/deoplete.nvim")
  call dein#add("Sirver/Ultisnips")
  call dein#add("honza/vim-snippets")
  call dein#add("tpope/vim-surround")
  call dein#add("zeis/vim-kolor")
  call dein#add("neomake/neomake")
  call dein#add("skywind3000/asyncrun.vim")
  call dein#add("Shougo/denite.nvim")
  call dein#add("easymotion/vim-easymotion")
  call dein#add("deton/tcvime")
  call dein#add("let-def/vimbufsync")
  " call dein#add("the-lambda-church/coquille")
  call dein#add("https://framagit.org/tyreunom/coquille.git")
  call dein#add("Yggdroot/indentLine")
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
	call dein#install()
endif
" }}}

" key behaviors {{{
if has('mac')
  nnoremap ; :
  nnoremap : ;
  vnoremap ; :
  vnoremap : ;
endif
inoremap <C-l> <Esc>
vnoremap <C-l> <Esc>
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap Y y$
" }}}

" code formatting {{{
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
" }}}

" look-and-feel {{{
if !has('gui_vimr')
	set t_ut=
endif
set number
colorscheme kolor
set matchtime=1
set foldmethod=marker
" }}}

" abbreviations {{{
abbr reuslt result
abbr itn int
" }}}

" miscellaneous {{{
set ignorecase
set incsearch
set showmatch
set backup
set backupdir=~/.nvim-backup
set undofile
set undodir=~/.nvim-undo
command EditConf e $MYVIMRC
" }}}

"deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

" Ultisnips {{{
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-f>"
let g:UltiSnipsJumpBackwardTrigger = "<C-b>"
" }}}

" neomake {{{
let g:neomake_open_list = 2
call neomake#configure#automake('nw', 750)
" }}}

" tcvime {{{
set keymap=tutcodep
set iminsert=0
set imsearch=0
let tcvime_keymap = 'tutcodep'
lmap <silent> <C-h> <C-R>=tcvime#InputPostConvertStart(0)<CR>
inoremap <C-j> <C-^>
" }}}

" vlime {{{
" workaround: dein seems to interfere with vlime in some way.
let g:vlime_cl_impl = "my_sbcl"
function! VlimeBuildServerCommandFor_my_sbcl(vlime_loader, vlime_eval)
  let s:actual_vlime_loader = expand('~/.cache/dein/repos/github.com/l04m33/vlime/lisp/load-vlime.lisp')
  return vlime#server#BuildServerCommandFor_sbcl(s:actual_vlime_loader, a:vlime_eval)
endfunction

let g:vlime_neovim_connector = "nc"
function! VlimeBuildConnectorCommandFor_nc(host, port, timeout)
  if type(a:timeout) == type(v:null)
    return ['nc', a:host, string(a:port)]
  else
    return ['nc', '-w', string(a:timeout / 1000.0), a:host, string(a:port)]
  endif
endfunction
" }}}

" indentLine {{{
let g:indentLine_color_term = 241
let g:indentLine_color_gui = '#555555'
let g:indentLine_char = '│'
" }}}

" coquille {{{
call coquille#Commands()
inoremap <C-c><C-n> <C-o>:CoqNext<CR>
nnoremap <C-c><C-n> :CoqNext<CR>
inoremap <C-c><C-c> <C-o>:CoqToCursor<CR>
nnoremap <C-c><C-c> :CoqToCursor<CR>
inoremap <C-c><C-u> <C-o>:<C-u>CoqUndo<CR>
nnoremap <C-c><C-u> :<C-u>CoqUndo<CR>
" }}}
