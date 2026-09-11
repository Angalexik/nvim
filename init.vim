"             _
"  _ ____   _(_)_ __ ___
" | '_ \ \ / | | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|

" User commands
runtime commands.vim

" Plugins
lua require("plugins")

" Key maps
lua require("mappings")

" Options
lua require("options")

" Misc
lua require("misc")

sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=

" TODO: Put this somewhere else
:let $LC_MESSAGES = "en-us"

lua << EOF
-- sus
require("editorconfig").properties.max_line_length = function (bufnr, val) end
EOF
