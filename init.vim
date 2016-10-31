" ___  ________   ___  _________    ___      ___ ___  _____ ______      
"|\  \|\   ___  \|\  \|\___   ___\ |\  \    /  /|\  \|\   _ \  _   \    
"\ \  \ \  \\ \  \ \  \|___ \  \_| \ \  \  /  / | \  \ \  \\\__\ \  \   
" \ \  \ \  \\ \  \ \  \   \ \  \   \ \  \/  / / \ \  \ \  \\|__| \  \  
"  \ \  \ \  \\ \  \ \  \   \ \  \ __\ \    / /   \ \  \ \  \    \ \  \ 
"   \ \__\ \__\\ \__\ \__\   \ \__\\__\ \__/ /     \ \__\ \__\    \ \__\
"    \|__|\|__| \|__|\|__|    \|__\|__|\|__|/       \|__|\|__|     \|__|

"dein Scripts----------------------------- {{{
" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('~/.cache/dein'))

" Let dein manage dein
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/deoplete.nvim')
call dein#add('SirVer/ultisnips')
call dein#add('honza/vim-snippets')
call dein#add('zchee/deoplete-clang')
call dein#add('Shougo/vimshell')
call dein#add('Shougo/vimproc', { 'build' : 'make'})
call dein#add('Shougo/denite.nvim')
call dein#add('VimClojure')
call dein#add('Shougo/vimshell')
call dein#add('Shougo/vimfiler')
call dein#add('cocopon/colorswatch.vim')
call dein#add('kana/vim-arpeggio')
call dein#add('itchyny/lightline.vim')
call dein#add('cohama/vim-hier')
call dein#add('dag/vim2hs', { 'on_ft' : 'haskell' })
call dein#add('pbrisbin/html-template-syntax', { 'on_ft' : 'html' })
call dein#add('derekwyatt/vim-scala', { 'on_ft': 'scala' })
call dein#add('kana/vim-smartchr')
call dein#add('vim-scripts/DrawIt', { 'lazy' : 1 })
call dein#add('vim-scripts/VimCoder.jar')
call dein#add('thinca/vim-template')
call dein#add('basyura/TweetVim')
call dein#add('mattn/webapi-vim')
call dein#add('tyru/open-browser.vim')
call dein#add('basyura/twibill.vim')
"call dein#add('KPCCoiL/neosnippet-snippets')
call dein#add('KPCCoiL/returnzero')
call dein#add('yuratomo/w3m.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('rbtnn/rabbit-ui.vim')
call dein#add('rbtnn/rabbit-ui-collection.vim')
call dein#add('mattn/gist-vim', {'depends': 'mattn/webapi-vim' })
call dein#add('altercation/vim-colors-solarized')
call dein#add('tpope/vim-fugitive')
call dein#add('mattn/excelview-vim')
call dein#add('tpope/vim-surround')
call dein#add('rbtnn/vimconsole.vim')
call dein#add('mopp/AOJ.vim')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('idris-hackers/idris-vim', { 'on_ft': 'idris'})
call dein#add('fatih/vim-go')
call dein#add('epdtry/neovim-coq')
call dein#add('thinca/vim-quickrun')

"Unite sources
call dein#add('ujihisa/unite-colorscheme')
call dein#add('h1mesuke/unite-outline')
call dein#add('osyo-manga/unite-quickfix')
call dein#add('tsukkee/unite-help')

" Platform specific plugins
if has('mac')
    dein#add('modsound/macdict-vim')
    dein#add('ryutorion/vim-itunes')
    dein#add('choplin/unite-spotlight')
    nnoremap ,us :<C-u>Unite spotlight
endif

" Required:
call dein#end()

" Required:
filetype plugin indent on

if dein#check_install()
  call dein#install()
endif
" }}}

" Load machine specific settings
source ${HOME}/.config/nvim/local_init.vim

"General settings------------------------ {{{
filetype plugin on
filetype indent on
set shellslash
set grepprg=grep\ -nH\ $*
set foldmethod=marker
set number
set incsearch
set autoread
set undofile
set undodir=$HOME/.vim-undo
set backup
set backupdir=$HOME/.vim-backup
set background=dark
set nrformats-=octal
set nrformats+=alpha
set ignorecase
set wildmode=longest:full,full
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set mouse=
set relativenumber
hi WarningMsg guifg=bg
inoremap () ()<Left>
inoremap {} {}<Left>
inoremap <> <><Left>
inoremap '' ''<Left>
inoremap `` ``<Left>
call arpeggio#map('i', '', 0,  'kl', '<Esc>')
inoremap <C-l> <Esc>
vnoremap <C-l> <Esc>
inoremap <Esc> <Nop>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nmap j gj
nmap k gk
nmap Y y$
colorscheme ron
so $VIMRUNTIME/macros/matchit.vim
" }}}

" Personal commands ---------------------- {{{
"binary file
augroup xxd
	autocmd!
	autocmd BufReadPost * if &l:binary | setlocal filetype=xxd |endif
augroup END
" }}}

" Plugin specific settings ---------------

" deoplete {{{
augroup deoplete_init
    autocmd!
    autocmd VimEnter * call deoplete#initialize()
let g:deoplete#enable_at_startup = 1
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" deoplete-clang {{{
let g:deoplete#sources#clang#sort_algo = "alphabetical"
" }}}
" }}}

" Ultisnips {{{
let g:UltiSnipsExpandTrigger = "<C-k>"
let g:UltiSnipsJumpBackwardTrigger = "<C-@>"
" }}}
