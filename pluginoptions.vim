lua << EOF

-- windwp/nvim-autopairs
local pairs = require("nvim-autopairs")
pairs.setup({
	enable_check_bracket_line = false
})

require("nvim-autopairs.completion.compe").setup({
	map_cr = true,
})

local Rule   = require'nvim-autopairs.rule'

pairs.add_rules({
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule('( ', ' )')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
  Rule('{ ', ' }')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
  Rule('[ ', ' ]')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']')
})

pairs.get_rule('"')
 :with_pair(function()
    if vim.bo.filetype == 'vim' then
       return false
   end
end)

-- nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
		disable = { "c_sharp" }
	},
	context_commentstring = { -- JoosepAlviste/nvim-ts-context-commentstring
		enable = true
	},
	autotag = { -- windwp/nvim-ts-autotag
		enable = true,
	},
}

-- lewis6991/gitsigns.nvim
require'gitsigns'.setup({
	yadm = {
		enable = true
	}
})

-- norcalli/nvim-colorizer.lua
require'colorizer'.setup({
	'*';
	css = { css = true };
	scss = { css = true };
	sass = { css = true };
}, { RGB = true, RRGGBB = true, RRGGBBAA = true, names = false})

-- ahmedkhalf/project.nvim
require'project_nvim'.setup({
	patterns = {
		'.git',
		'.git/',
		'_darcs/',
		'.hg/',
		'.bzr/',
		'.svn/',
		'gradle/',
		'Cargo.toml',
		'tsconfig.json',
		'*.sln',
		'*.csproj',
		'Makefile'
	}
})

-- kyazdani42/nvim-web-devicons
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

" theHamsta/nvim-dap-virtual-text
let g:dap_virtual_text = v:true

" arcticicestudio/nord-vim
let g:nord_italic = 1
let g:nord_italic_comments = 1

" romgrk/barbar.nvim
let g:bufferline = get(g:, 'bufferline', {})
let g:bufferline.icon_custom_colors = 'white'

" OmniSharp/omnisharp-vim
let g:OmniSharp_highlighting = 3
let g:OmniSharp_typeLookupInPreview = 1

" lukas-reineke/indent-blankline.nvim
let g:indent_blankline_buftype_exclude = ['terminal', 'help']
let g:indent_blankline_filetype_exclude = ['startify']
let g:indent_blankline_char = "│"
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_current_context = v:true
let g:indent_blankline_context_patterns = ['function', 'class', 'method', 'namespace', '^using', '^for', '^if', '^else', '^table', '^dictionary', '^list', '^while', '^try', '^except', '^finally', '^handler', '^finalizer', '^alternative', '^switch', 'case']

" iamcco/markdown-preview.nvim
let g:mkdp_markdown_css = expand('~/.config/nvim/markdown.css')
let g:mkdp_page_title = '„${name}“'

