"setting for colorscheme
syntax enable
colorscheme solarized
augroup cursorsettings
	autocmd!
	autocmd FileType c,cpp,haskell,html,vim,ruby,python,sh set cursorline |set cursorcolumn
augroup END
highlight CursorLineNr guifg=#839496

"multi_byte ime
set noimdisableactivate
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
if(time>=16)
	call s:Dark()
else 
	call s:Light()
endif
"
"normal settings
set visualbell t_vb=
if !has(mac)
	set mouse=
endif
