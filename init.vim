"             _
"  _ ____   _(_)_ __ ___
" | '_ \ \ / | | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|

" temporary
set runtimepath^=/home/alex/dotfiles/coc-computercraft

" Plugins
runtime plugins.vim

" Options
runtime options.vim

" Lsp configuration
lua require("lsp")

" Status line
lua require('statusline')

" Debugging
lua require('debugging')

" Compe
lua require('completion')

" Key maps
runtime mappings.vim

" Set up devicons
lua << EOF

local devicons = require'nvim-web-devicons'

devicons.setup {
	override = {
		txt = {
			icon = "",
			color = "#6d8086",
			name = "Text"
		}
	}
}

-- Startify devicons
function _G.webDevIcons(path)
 	local filename = vim.fn.fnamemodify(path, ':t')
 	local extension = vim.fn.fnamemodify(path, ':e')
 	return devicons.get_icon(filename, extension, { default = true })
end

EOF

function! StartifyEntryFormat() abort
 	return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
endfunction

let g:dap_virtual_text = v:true

" Vim rooter
let g:rooter_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/', 'gradle/', 'Cargo.toml', 'tsconfig.json', '*.sln', '*.csproj', 'Makefile']

" Visual settings
let g:nord_italic = 1
let g:nord_italic_comments = 1
colorscheme nord

lua <<EOF

require'gitsigns'.setup({
	yadm = {
		enable = true
	}
})

require'colorizer'.setup({
	'*';
	css = { css = true };
	scss = { css = true };
	sass = { css = true };
}, { RGB = true, RRGGBB = true, RRGGBBAA = true, names = false})

EOF

" Highlights
highlight StatusLine guifg=#2e3440 guibg=#2e3440 ctermbg=black ctermbg=black
highlight link StatusLineNC StatusLine
highlight link StatusLineTerm StatusLine
highlight link StatusLineTermNC StatusLine

sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=

" Barbar

let g:bufferline = get(g:, 'bufferline', {})

let g:bufferline.icon_custom_colors = 'white'

" Treesitter settings
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true,							-- false will disable the whole extension
		disable = { "c_sharp" }
	},
	context_commentstring = {
		enable = true
	}
}
EOF

" Indentline
let g:indent_blankline_buftype_exclude = ['terminal', 'help']
let g:indent_blankline_filetype_exclude = ['startify']
let g:indent_blankline_char = "│"
let g:indent_blankline_use_treesitter = v:true

" Close tag
lua <<EOF
require'nvim-treesitter.configs'.setup {
	autotag = {
		enable = true,
	}
}
EOF

" Markdown settings
let g:mkdp_markdown_css = expand('~/.config/nvim/markdown.css')
let g:mkdp_page_title = '„${name}“'

" Allow json comments
autocmd FileType json setlocal filetype=jsonc

" Custom comments for vim-commetary
autocmd FileType jsonc setlocal commentstring=//\ %s
autocmd FileType kerboscript setlocal commentstring=//\ %s

if filereadable('gradlew')
	compiler gradlew
endif

" Omnisharp settings
let g:OmniSharp_highlighting = 3
let g:OmniSharp_typeLookupInPreview = 1

lua <<EOF

-- Autopairs
local pairs = require("nvim-autopairs")
pairs.setup()

require("nvim-autopairs.completion.compe").setup({
	map_cr = true,
})

local Rule   = require'nvim-autopairs.rule'

pairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col, opts.col + 1)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ',' )')
        :with_pair(function() return false end)
        :with_move(function() return true end)
        :use_key(")")
}

pairs.get_rule('"')
 :with_pair(function()
    if vim.bo.filetype == 'vim' then
       return false
   end
end)

EOF
