"             _
"  _ ____   _(_)_ __ ___
" | '_ \ \ / | | '_ ` _ \
" | | | \ V /| | | | | | |
" |_| |_|\_/ |_|_| |_| |_|


" Plugins
call plug#begin('~/.nvim_plugins')

" Plugin dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Colour scheme
Plug 'Angalexik/nord-vim'
Plug 'dracula/vim'
Plug 'reedes/vim-colors-pencil'
" Plug 'folke/lsp-colors.nvim'

" QOL
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'Angalexik/vim-sleuth'
Plug 'tpope/vim-sensible'
Plug 'airblade/vim-rooter'
Plug 'alvan/vim-closetag'
Plug 'ggandor/lightspeed.nvim'
" Plug 'LucHermitte/local_vimrc'
" Plug 'LucHermitte/lh-vim-lib'
Plug 'windwp/nvim-ts-autotag'
Plug 'windwp/nvim-autopairs'
Plug 'nvim-telescope/telescope.nvim'
Plug 'yuttie/comfortable-motion.vim'
Plug 'jbyuki/one-small-step-for-vimkind'

" Completion/LSP
" Plug 'dense-analysis/ale'
" Plug 'nathunsmitty/nvim-ale-diagnostic'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'onsails/lspkind-nvim'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'folke/lua-dev.nvim'
Plug 'mfussenegger/nvim-lint'

" Snippets
Plug 'fivethree-team/vscode-svelte-snippets'

" Various FileType support
Plug 'Pocco81/DAPInstall.nvim'
Plug 'mfussenegger/nvim-dap'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'puremourning/vimspector'
Plug 'mattn/emmet-vim'
Plug 'evanleck/vim-svelte'
Plug 'liuchengxu/vista.vim'
Plug 'digitaltoad/vim-pug'
" Plug 'kevinoid/vim-jsonc'
Plug 'Freedzone/kerbovim'
Plug 'maxbane/vim-asm_ca65'
Plug 'OmniSharp/omnisharp-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" Plug 'cespare/vim-toml'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'tpope/vim-markdown'
Plug 'clktmr/vim-gdscript3'
" Plug 'DonnieWest/kotlin-vim'
" Plug 'tfnico/vim-gradle'
Plug 'rubixninja314/vim-mcfunction'
Plug 'neoclide/npm.nvim', {'do': 'npm install'}

" Visual changes
Plug 'airblade/vim-gitgutter'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'glepnir/galaxyline.nvim'
Plug 'mhinz/vim-startify'
Plug 'junegunn/goyo.vim'
" Plug 'ryanoasis/vim-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

" Auto install
autocmd VimEnter *
	\  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\|	 PlugInstall --sync | q
	\| endif

" temporary
set runtimepath^=/home/alex/dotfiles/coc-computercraft

" Lsp configuration
lua require("lsp")

" Status line
lua require('statusline')

" Debugging
lua require('debugging')

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

" Remaps
let mapleader = ' '
" Fast save
map <leader>w :w!<cr>
" Fast search
map <leader><space> /
map <leader><C-space> ?
" Change to writing mode
nmap <leader>zz :source ~/.config/nvim/markdown.vim<cr>
" Enable mouse
set mouse=a
" Exit terminal
tnoremap <esc> <C-\><C-N>

" Dap
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <S-<F11>> :lua require'dap'.step_out()<CR>
nnoremap <silent> <S-<F5>> :lua require'dap'.disconnect()<CR>
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F6> :lua require'dap'.pause()<CR>
nnoremap <silent> <F9> :lua require'dap'.toggle_breakpoint()<CR>

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

" Gitgutter symbols
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_modified_removed = '~'

" Keep buffers after abandoning
set hidden

" Barbar
" Move to previous/next
nnoremap <silent>		 <A-,> :BufferPrevious<CR>
nnoremap <silent>		 <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>		 <A-<> :BufferMovePrevious<CR>
nnoremap <silent>		 <A->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>		 <A-1> :BufferGoto 1<CR>
nnoremap <silent>		 <A-2> :BufferGoto 2<CR>
nnoremap <silent>		 <A-3> :BufferGoto 3<CR>
nnoremap <silent>		 <A-4> :BufferGoto 4<CR>
nnoremap <silent>		 <A-5> :BufferGoto 5<CR>
nnoremap <silent>		 <A-6> :BufferGoto 6<CR>
nnoremap <silent>		 <A-7> :BufferGoto 7<CR>
nnoremap <silent>		 <A-8> :BufferGoto 8<CR>
nnoremap <silent>		 <A-9> :BufferLast<CR>
" Close buffer
nnoremap <silent>		 <A-c> :BufferClose<CR>
" Wipeout buffer
"													 :BufferWipeout<CR>
" Close commands
"													 :BufferCloseAllButCurrent<CR>
"													 :BufferCloseBuffersLeft<CR>
"													 :BufferCloseBuffersRight<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-s>		 :BufferPick<CR>

let g:bufferline = get(g:, 'bufferline', {})

let g:bufferline.icon_custom_colors = 'white'
highlight! BufferTabpageFill guifg=#d8dee9 guibg=#2e3440

highlight! BufferCurrent guifg=#d8dee9 guibg=#4c566a
highlight link BufferCurrentIndex BufferCurrent
highlight link BufferCurrentSign BufferCurrent
highlight! BufferCurrentMod guifg=#88c0d0 guibg=#4c566a
highlight! BufferCurrentTarget guifg=#bf616a guibg=#4c566a

highlight link BufferVisible BufferCurrent
highlight link BufferVisibleMod BufferCurrentMod
highlight link BufferVisibleIndex BufferCurrentIndex
highlight link BufferVisibleSign BufferCurrentSign
highlight link BufferVisibleTarget BufferCurrentTarget

highlight! BufferInactive guifg=#616e88 guibg=#2e3440
highlight link BufferInactiveIndex BufferInactive
highlight link BufferInactiveSign BufferInactive
highlight! BufferInactiveSign guifg=#d8dee9 guibg=#2e3440
highlight! BufferInactiveMod guifg=#88c0d0 guibg=#2e3440
highlight! BufferInactiveTarget guifg=#bf616a guibg=#2e3440


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
" let g:markdown_enable_spell_checking = 0

" Fold settings
set foldmethod=marker
set foldmarker=#region,#endregion

" Allow json comments
autocmd FileType json setlocal filetype=jsonc

" Custom comments for vim-commetary
autocmd FileType jsonc setlocal commentstring=//\ %s
autocmd FileType kerboscript setlocal commentstring=//\ %s
" autocmd FileType svelte setlocal commentstring=<!--\ %s\ -->

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

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

EOF
