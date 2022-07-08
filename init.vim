"             _
"  _ ____   _(_)_ __ ___
" | '_ \ \ / | | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|

" Plugins
runtime plugins.vim

" Options
runtime options.vim

" Plugin Options
runtime pluginoptions.vim

" Lsp configuration
lua require("lsp")

" Status line
lua require('new_statusline')

" Compe
lua require('completion')

" Key maps
runtime mappings.vim

" User commands
runtime commands.vim

" Visual settings
colorscheme nord

" Highlights
highlight StatusLine guifg=#2e3440 guibg=#2e3440 ctermbg=black ctermbg=black
highlight link StatusLineNC StatusLine
highlight link StatusLineTerm StatusLine
highlight link StatusLineTermNC StatusLine

sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=

" Allow json comments
autocmd FileType json setlocal filetype=jsonc

" Custom comments for vim-commetary
autocmd FileType jsonc setlocal commentstring=//\ %s
autocmd FileType kerboscript setlocal commentstring=//\ %s

if filereadable('gradlew')
	compiler gradlew
endif
