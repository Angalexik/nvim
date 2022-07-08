local g = vim.g

-- windwp/nvim-autopairs
local pairs = require("nvim-autopairs")
pairs.setup({
	enable_check_bracket_line = false
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

pairs.get_rule('"')[1]
 :with_pair(function()
    if vim.bo.filetype == 'vim' then
       return false
   end
end)

-- nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
	ensure_installed = "all",
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

-- goolord/alpha-nvim
require'alpha'.setup(require'dashboard'.config)

-- arcticicestudio/nord-vim
g.nord_italic = 1
g.nord_italic_comments = 1

-- romgrk/barbar.nvim
require('bufferline').setup({
	icon_custom_colors = "white",
})

-- OmniSharp/omnisharp-vim
g.OmniSharp_highlighting = 3
g.OmniSharp_typeLookupInPreview = 1

-- lukas-reineke/indent-blankline.nvim
require('indent_blankline').setup({
	buftype_exclude = {'terminal', 'help'},
	filetype_exclude = {'alpha'},
	char = "│",
	use_treesitter = true,
	show_current_context = true,
	context_patterns = {'function', 'class', 'method', 'namespace', '^using', '^for', '^if', '^else', '^table', '^dictionary', '^list', '^while', '^try', '^except', '^finally', '^handler', '^finalizer', '^alternative', '^switch', 'case'},
})

-- rrethy/vim-hexokinase
g.Hexokinase_highlighters = {'virtual'}
g.Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

-- Olical/aniseed
g["aniseed#env"] = true
