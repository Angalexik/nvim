try
	echo vimmarkdownwritemode
catch /.*/
	let vimmarkdownwritemode = 0
endtry

if vimmarkdownwritemode
	set background=dark
	colorscheme nord
	set conceallevel=0
	Goyo!
	let vimmarkdownwritemode = 0
else
	set background=light
	set conceallevel=2
	let g:pencil_neutral_headings = 1
	let g:pencil_neutral_code_bg = 1
	let g:pencil_terminal_italics = 1

	colorscheme pencil

	let vimmarkdownwritemode = 1

	Goyo
endif
