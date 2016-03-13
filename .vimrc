"          _____                         
"   ___   ____(_)______ _________________
"   __ | / /_  /__  __ `__ \_  ___/  ___/
"_____ |/ /_  / _  / / / / /  /   / /__  
"_(_)____/ /_/  /_/ /_/ /_//_/    \___/  
                                        
" Vim-LaTeX
filetype plugin on
filetype indent on
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 1
let g:Imap_DeleteEmptyPlaceHolders = 1
let g:Imap_StickyPlaceHolders = 0
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_FormatDependency_ps = 'dvi,ps'
let g:Tex_FormatDependency_pdf = 'dvi, pdf'

"Setting of each environment
if has('mac')
	imap <D-i> <Return><A-i>
	let g:Tex_CompileRule_dvi = '/usr/texbin/platex -synctex=1 -interaction=nonstopmode $*'
	let g:Tex_CompileRule_ps = '/usr/texbin/dvips -Ppdf -o $*.ps $*.dvi'
	"let g:Tex_CompileRule_pdf = '/usr/texbin/dvipdfmx $*.dvi'
	let g:Tex_CompileRule_pdf = '/usr/local/texlive/2015/bin/x86_64-darwin/lualatex -synctex=1 -interaction=nonstopmode -file-line-error-style $*'
	let g:Tex_BibtexFlavor = '/usr/texbin/pbibtex'
	let g:Tex_MakeIndexFlavor = '/usr/texbin/mendex $*.idx'
	let g:Tex_UseEditorSettingInDVIViewer = 1
	let g:Tex_ViewRule_dvi = '/usr/bin/open -a PictPrinter.app'
	let g:Tex_ViewRule_ps = '/usr/local/bin/gv --watch'
	let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview.app'
	let g:Tex_FormatDependency_pdf = ''
elseif has('unix')
	let g:Tex_CompileRule_pdf = 'platex -u -l -ot "-synctex=1 -interaction=nonstopmode -file-line-error-style" $*'
	let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
	let g:Tex_CompileRule_dvi = 'dvipdfmx'
	let g:Tex_BibtexFlavor = 'upbibtex'
	let g:Tex_MakeIndexFlavor = 'makeindex $*.idx'
	let g:Tex_UseEditorSettingInDVIViewer = 1
	let g:Tex_ViewRule_pdf = 'epdfview'
endif
"
"normal setting
set number
hi WarningMsg guifg=bg
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

"keymaps
inoremap () ()<++><Left><Left><Left><Left><Left>
inoremap {} {}<++><Left><Left><Left><Left><Left>
inoremap [] []<++><Left><Left><Left><Left><Left>
inoremap "" ""<++><Left><Left><Left><Left><Left>
inoremap <> <><++><Left><Left><Left><Left><Left>
inoremap '' ''<++><Left><Left><Left><Left><Left>
inoremap `` ``<++><Left><Left><Left><Left><Left>
if has('mac')
	nnoremap ; :
	vnoremap ; :
	nnoremap : ;
	vnoremap : ;
endif
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nmap j gj
nmap k gk
nmap Y y$
nnoremap <Leader>rr :<C-u>SCCompileRun<CR>

"some commands
"、。->,.
command! -nargs=0 Zenhan call s:zenhan()
function! s:zenhan()
	%s/、/,/g
	%s/。/./g
endfunction
"count chars
command! -nargs=0 -range=% Count :<line1>,<line2>s/./&/gn | :noh
"delete hlsearch
command! -nargs=0 Delhl /aaaaaaaaa
"awk calc
function! s:Calc(expression)
	execute "VimProcBang awk \"BEGIN{print ".a:expression."}\""
endfunction
command! -nargs=* Calc call s:Calc(<f-args>)
"syntaxinfo
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
"reload vimrc & gvimrc
function! s:Rercs()
	source ~/.vimrc
	source ~/.gvimrc
endfunction
command! Reloadvimrc call s:Rercs()
function! s:cliprun()
	if &filetype=='haskell'
		if glob(expand('%:r')) != ''
			let s:runcmd='./'
		else
			let s:runcmd='runhaskell '
		endif
	elseif &filetype=='cpp'
		let s:runcmd='./'
	endif
	if has('mac')
		let s:clipcmd='pbpaste'
	elseif has('unix')
		let s:clipcmd='xsel -bo'
	endif
	execute '!'.s:clipcmd.'|'.s:runcmd.expand('%:r')
endfunction
command! ClipRun call s:cliprun()
"tweet progress
function! s:ask_progress()
	let s:progress=input("進捗どうですか? (good/bad) : ")
	if s:progress=="good"
		let s:shinchoku='大丈夫です'
	elseif s:progress=="bad"
		let s:shinchoku='ダメです'
	else
		echoerr "Invalid progress"
	endif
	execute "TweetVimCommandSay 進捗" . s:shinchoku
endfunction
command! Shinchoku call s:ask_progress()
"binary file
augroup xxd
	autocmd!
	autocmd BufReadPost * if &l:binary | setlocal filetype=xxd |endif
augroup END

"setting for Neobundle
set nocompatible               " be iMproved
filetype off

"Plugins
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shogo/neobundle.vim'
    NeoBundle 'Shougo/vimproc',{
                \'build' :{
                \'mac':'make -f make_mac.mak',
                \'unix':'make -f make_unix.mak',
                \},
                \}
    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'VimClojure'
    NeoBundle 'Shougo/vimshell'
    if has('lua')
        NeoBundle 'Shougo/neocomplete.vim'
    else
        NeoBundle 'Shougo/neocomplcache.vim'
    endif
    NeoBundle 'Shougo/neosnippet'
    NeoBundle 'Shougo/vimfiler'
    NeoBundle 'xuhdev/SingleCompile'
    NeoBundle 'cocopon/colorswatch.vim'
    NeoBundleLazy 'thinca/vim-scouter',{
                \"autoload" : {"commands" : ["Scouter"]}}
    NeoBundle 'itchyny/lightline.vim'
    NeoBundle 'cohama/vim-hier'
    NeoBundleLazy 'dag/vim2hs',{
                \"autoload" : {"filetypes" : ["haskell"]}}
    NeoBundleLazy 'eagletmt/ghcmod-vim',{
                \"autoload" : {"filetypes" : ["haskell"]}}
    NeoBundleLazy 'pbrisbin/html-template-syntax',{
                \"autoload" : {"filetypes" : ["html"]}}
    NeoBundleLazy 'eagletmt/neco-ghc',{
                \"autoload" : {"filetypes" : ["haskell"]}}
    NeoBundle 'derekwyatt/vim-scala'
    NeoBundle 'kana/vim-smartchr'
    NeoBundle 'vim-scripts/DrawIt'
    NeoBundle 'vim-scripts/VimCoder.jar'
    NeoBundle 'thinca/vim-template'
    NeoBundle 'basyura/TweetVim'
    NeoBundle 'mattn/webapi-vim'
    NeoBundle 'tyru/open-browser.vim'
    NeoBundle 'basyura/twibill.vim'
    NeoBundle 'KPCCoiL/neosnippet-snippets'
    NeoBundle 'KPCCoiL/prf-copl'
    NeoBundle 'KPCCoiL/returnzero'
    NeoBundle 'yuratomo/w3m.vim'
    NeoBundle 'Shougo/neomru.vim'
    NeoBundle 'rbtnn/rabbit-ui.vim'
    NeoBundle 'rbtnn/rabbit-ui-collection.vim'
    NeoBundle 'mattn/gist-vim', {'depends': 'mattn/webapi-vim'}
    NeoBundleLazy 'supermomonga/jazzradio.vim', { 'depends' : [ 'Shougo/unite.vim' ] }
    if neobundle#tap('jazzradio.vim')
        call neobundle#config({
                    \   'autoload' : {
                    \     'unite_sources' : [
                    \       'jazzradio'
                    \     ],
                    \     'commands' : [
                    \       'JazzradioUpdateChannels',
                    \       'JazzradioStop',
                    \       {
                    \         'name' : 'JazzradioPlay',
                    \         'complete' : 'customlist,jazzradio#channel_id_complete'
                    \       }
                    \     ],
                    \     'function_prefix' : 'jazzradio'
                    \   }
                    \ })
    endif
    if has('mac')
        NeoBundle 'modsound/macdict-vim'
        NeoBundle 'ryutorion/vim-itunes'
    endif
    NeoBundle 'jcf/vim-latex'
    NeoBundle 'altercation/vim-colors-solarized'
    NeoBundle 'tpope/vim-fugitive'
    NeoBundle 'mattn/excelview-vim'
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'rbtnn/vimconsole.vim'
    NeoBundle 'mopp/AOJ.vim'
    NeoBundle 'heavenshell/vim-slack'
    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'idris-hackers/idris-vim'
    NeoBundle '0x0dea/vim-molasses'
    NeoBundle 'derekelkins/agda-vim'

    "Unite sources
    NeoBundle 'ujihisa/unite-colorscheme'
    NeoBundle 'h1mesuke/unite-outline'
    NeoBundle 'osyo-manga/unite-quickfix'
    NeoBundle 'tsukkee/unite-help'
    if has('mac')
        NeoBundle 'choplin/unite-spotlight'
        nnoremap ,us :<C-u>Unite spotlight
    endif
    call neobundle#end()
endif
NeoBundleCheck

filetype plugin indent on     " required!
filetype indent on
syntax on

"Setting for Neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
imap <C-k> <Plug>(neosnippet_expand_or_jump)
vmap <expr><Tab> neosnippet#expandable() ? "\<Plug>(neosnippet_jump_or_expand)" : "\<Tab>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-b>     neocomplete#complete_common_string()

"Setting for Unite
let g:unite_source_history_yank_enable = 1
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,uc :<C-u>Unite colorscheme -auto-preview<CR>
nnoremap <silent> ,uo :<C-u>Unite output<CR>
nnoremap <silent> ,ul :<C-u>Unite outline<CR>
nnoremap <silent> ,uq :<C-u>Unite -no-quit -direction=botright -winheight=9 quickfix<CR>
nnoremap <silent> ,uh :<C-u>Unite help<CR>
nnoremap <silent> ,up :<C-u>Unite process<CR>

"SingleCompile
let common_run_command = './$(FILE_TITLE)$'
call SingleCompile#SetCompilerTemplate(
    \ 'cpp', 'g++ 11', 
    \ 'GNU C++ Compiler',
    \'g++', '-std=c++11 -g -o $(FILE_TITLE)$', 
    \common_run_command)
call SingleCompile#SetCompilerTemplate(
    \ 'cpp', 'clang++ 14',
    \ 'clang C++ Compiler',
    \ 'clang++-3.6', '-std=c++1y -g -o $(FILE_TITLE)$',
    \ common_run_command)
let emrun = 'node $(FILE_TITLE)$.js'
call SingleCompile#SetCompilerTemplate(
    \ 'cpp', 'em++', 
    \ 'enscripten Compiler', has('mac')?'~/emscripten/em++' : 'em++', '-O3 --closure 1 -o $(FILE_TITLE)$.js', 
    \emrun)
call SingleCompile#ChooseCompiler('cpp','g++ 11')
call SingleCompile#SetCompilerTemplate(
	\ 'scheme','gosh',
	\ 'Gauche',
	\ 'gosh',
	\ '',
	\ '')
call SingleCompile#ChooseCompiler('scheme','gosh')

"vim-smartchr
augroup chars
	autocmd!
	autocmd FileType c,cpp,ruby,python,sh inoremap <buffer> <expr> = smartchr#loop(' = ',' == ','=',' = <++><Left><Left><Left><Left><Left><Left>')
	autocmd FileType haskell inoremap <buffer> <expr> - smartchr#loop('-','-- ',' -> ',' <- ')
	autocmd FileType haskell inoremap <buffer> <expr> = smartchr#loop(' = ',' == ','=',' = <++><Left><Left><Left><Left><Left><Left>')
	autocmd FileType haskell inoremap <buffer> <expr> > smartchr#loop('>',' >> ',' >>= ',' > ')
	autocmd FileType haskell inoremap <buffer> <expr> < smartchr#loop('<',' =<< ',' < ')
augroup END

"setting for VimShell
let g:vimshell_prompt_expr = 'getcwd()." > "'
let g:vimshell_prompt_pattern='^\f\+ > '
let g:vimshell_secondary_prompt = "> "
nnoremap ,vp :<C-u>VimShellPop<CR>
nnoremap ,vt :<C-u>VimShellTab<CR>
nnoremap ,vs :<C-u>VimShell<CR>
nnoremap ,gh :<C-u>VimShellInteractive ghci<CR>

"Setting for VimFiler
let g:vimfiler_as_default_explorer=1
nnoremap ,vf :<C-u>VimFiler<CR>

"auto new dir
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'))
  function! s:auto_mkdir(dir)  " {{{
    if !isdirectory(a:dir)
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

"enable matchit.vim
so $VIMRUNTIME/macros/matchit.vim

"Tweetvim
nnoremap ,tw :<C-u>TweetVimCommandSay<CR>
command! HomeTwitter :TweetVimHomeTime

"returnzero
imap <CR> <Plug>(returnzero)

"vim-indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 1

"setting for lightline
let g:lightline = {
			\ 'colorscheme': (has('gui_running')?'solarized': 'default'),
			\ 'mode_map': {'c': 'NORMAL'},
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
			\ },
			\ 'component_function': {
			\   'modified': 'MyModified',
			\   'readonly': 'MyReadonly',
			\   'fugitive': 'MyFugitive',
			\   'filename': 'MyFilename',
			\   'fileformat': 'MyFileformat',
			\   'filetype': 'MyFiletype',
			\   'fileencoding': 'MyFileencoding',
			\   'mode': 'MyMode'
			\ }
			\ }
function! MyModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
	return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
				\  &ft == 'unite' ? unite#get_status_string() :
				\  &ft == 'vimshell' ? vimshell#get_status_string() :
				\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
	try
		if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
			return fugitive#head()
		endif
	catch
	endtry
	return ''
endfunction

function! MyFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
