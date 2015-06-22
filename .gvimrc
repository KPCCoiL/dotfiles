"                                                                      
"                              _/                                      
"         _/_/_/  _/      _/      _/_/_/  _/_/    _/  _/_/    _/_/_/   
"      _/    _/  _/      _/  _/  _/    _/    _/  _/_/      _/          
"     _/    _/    _/  _/    _/  _/    _/    _/  _/        _/           
"_/    _/_/_/      _/      _/  _/    _/    _/  _/          _/_/_/      
"         _/                                                           
"    _/_/                                                              
"setting for colorscheme
syntax enable
colorscheme solarized
augroup cursorsettings
	autocmd!
	autocmd FileType c,cpp,haskell,html,vim,ruby,python,sh set cursorline |set cursorcolumn
augroup END
highlight CursorLineNr guifg=#839496

"multi_byte ime
if has('mac')
	set noimdisableactivate
endif
if has('multi_byte_ime') || has('xim')
	highlight Cursor guifg=NONE guibg=#839496
	highlight CursorIM guifg=NONE guibg=#b58900
endif

"vim_hier
execute "highlight qf_error_ucurl gui=undercurl guisp=Red"
let g:hier_highlight_group_qf  = "qf_error_ucurl"
execute "highlight qf_warning_ucurl gui=undercurl guisp=Blue"
let g:hier_highlight_group_qfw = "qf_warning_ucurl"

"background changer
function! s:Light()
	set background=light
	if has('multi_byte_ime') || has('xim')
		highlight Cursor guifg=NONE guibg=#93a1a1
		highlight CursorIM guifg=NONE guibg=#b58900
		highlight CursorLineNr guifg=#002b36
	endif
endfunction
command! -nargs=0 Light call s:Light()

"vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1

function! s:Dark()
	set background=dark
	if has('multi_byte_ime') || has('xim')
		highlight Cursor guifg=NONE guibg=#839496
		highlight CursorIM guifg=NONE guibg=#b58900
		highlight CursorLineNr guifg=#839496
	endif
endfunction
command! -nargs=0 Dark call s:Dark()
let time=localtime()
let now=strftime("%H",time)
if(now >= 16)
	call s:Dark()
else 
	call s:Light()
endif
"
"normal settings
set visualbell t_vb=
if !has('mac')
	set mouse=
	set guioptions-=m
	set guioptions-=T
	set guioptions-=r
	set guifont=Ricty\ Discord\ 13
endif
