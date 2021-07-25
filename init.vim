"             _
"  _ ____   _(_)_ __ ___
" | '_ \ \ / | | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|

" temporary
set runtimepath^=/home/alex/dotfiles/coc-computercraft

" Plugins
runtime plugins.vim

" Lsp configuration
lua require("lsp")

" Status line
lua require('statusline')

" Debugging
lua require('debugging')

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

" Enable mouse
set mouse=a
let g:dap_virtual_text = v:true

" Vim rooter
let g:rooter_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/', 'gradle/', 'Cargo.toml', 'tsconfig.json', '*.sln', '*.csproj', 'Makefile']

" Visual settings
let g:nord_italic = 1
let g:nord_italic_comments = 1
colorscheme nord
set encoding=UTF-8
set relativenumber
set number
set breakindent
set termguicolors
set noshowmode
set signcolumn=yes:1
set scrolloff=2

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

" Keep buffers after abandoning
set hidden

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

" Search
set ignorecase
set smartcase

" Clipboard
set clipboard=unnamedplus

" Indentline
let g:indent_blankline_buftype_exclude = ['terminal', 'help']
let g:indent_blankline_filetype_exclude = ['startify']
let g:indent_blankline_char = "│"
let g:indent_blankline_use_treesitter = v:true

" Indentation
set tabstop=2
set shiftwidth=2
set noexpandtab

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

" Fold settings
set foldmethod=marker
set foldmarker=#region,#endregion

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

" Speed up CursorHold
set updatetime=300

" nvim compe
set completeopt=menuone,noselect

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:false
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:false

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

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
		local col = vim.fn.col('.') - 1
		if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
				return true
		else
				return false
		end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t "<C-n>"
	elseif vim.fn.call("vsnip#available", {1}) == 1 then
		return t "<Plug>(vsnip-expand-or-jump)"
	elseif check_back_space() then
		return t "<Tab>"
	else
		return vim.fn['compe#complete']()
	end
end
_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t "<C-p>"
	elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
		return t "<Plug>(vsnip-jump-prev)"
	else
		-- If <S-Tab> is not working in your terminal, change it to <C-h>
		return t "<S-Tab>"
	end
end

EOF
