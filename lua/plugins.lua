local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Plugin dependencies
	{
		"nvim-lua/popup.nvim",
		lazy = true,
	},
	"nvim-lua/plenary.nvim",
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = {
			override = {
				txt = {
					icon = "",
					color = "#6d8086",
					name = "Text",
				},
			},
		},
	},
	{
		"rktjmp/hotpot.nvim",
		lazy = false,
		priority = 1001,
	},
	-- Colour scheme
	{
		"arcticicestudio/nord-vim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.nord_italic = 1
			vim.g.nord_italic_comments = 1
			vim.cmd("colorscheme nord")
			require("highlights")
		end,
	},
	-- QOL
	{
		"akinsho/toggleterm.nvim",
		opts = {
			open_mapping = [[<C-'>]],
			shade_terminals = false,
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				hidden = true,
				direction = "float",
				float_opts = {
					boarder = "curved",
				},
				close_on_exit = true,
				on_open = function(term)
					vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<ESC>", {})
					vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-[>", "<C-[>", {})
				end,
			})

			local function lazygit_toggle()
				lazygit:toggle()
			end

			vim.api.nvim_create_user_command("Lazygit", lazygit_toggle, {})
		end,
	},
	{
		"lilydjwg/fcitx.vim",
		event = "InsertEnter",
		config = function()
			vim.g.fcitx5_remote = "/usr/bin/fcitx5-remote"
		end,
	},
	{ "eraserhd/parinfer-rust", build = "cargo build --release" },
	"tpope/vim-surround",
	"tpope/vim-commentary",
	"tpope/vim-fugitive",
	"tpope/vim-repeat",
	"Angalexik/vim-sleuth",
	"tpope/vim-sensible",
	{
		"stevearc/oil.nvim",
		config = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	"editorconfig/editorconfig-vim",
	{
		"ahmedkhalf/project.nvim",
		main = "project_nvim",
		opts = {
			patterns = {
				".git",
				".git/",
				"_darcs/",
				".hg/",
				".bzr/",
				".svn/",
				"gradle/",
				"Cargo.toml",
				"tsconfig.json",
				"*.sln",
				"*.csproj",
				"Makefile",
			},
		},
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"ggandor/flit.nvim",
		config = true,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			local pairs = require("nvim-autopairs")
			pairs.setup({
				enable_check_bracket_line = false,
			})

			local Rule = require("nvim-autopairs.rule")

			pairs.add_rules({
				Rule(" ", " "):with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({ "()", "[]", "{}" }, pair)
				end),
				Rule("( ", " )")
						:with_pair(function()
							return false
						end)
						:with_move(function(opts)
							return opts.prev_char:match(".%)") ~= nil
						end)
						:use_key(")"),
				Rule("{ ", " }")
						:with_pair(function()
							return false
						end)
						:with_move(function(opts)
							return opts.prev_char:match(".%}") ~= nil
						end)
						:use_key("}"),
				Rule("[ ", " ]")
						:with_pair(function()
							return false
						end)
						:with_move(function(opts)
							return opts.prev_char:match(".%]") ~= nil
						end)
						:use_key("]"),
			})

			pairs.get_rule('"')[1]:with_pair(function()
				if vim.bo.filetype == "vim" then
					return false
				end
			end)
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "debugloop/telescope-undo.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					undo = {
						side_by_side = true,
						layout_strategy = "vertical",
						layout_config = {
							preview_height = 0.8,
						},
					},
				},
			})

			require("telescope").load_extension("undo")
		end,
	},
	"psliwka/vim-smoothie",
	{
		"mg979/vim-visual-multi",
		branch = "master",
	},
	{
		"skywind3000/asyncrun.vim",
		cmd = "AsyncRun",
	},
	"tommcdo/vim-exchange",
	"wellle/targets.vim",
	"moll/vim-bbye",
	{
		"willothy/flatten.nvim",
		config = true,
		lazy = false,
		priority = 2000,
	},
	-- Completion/LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("lsp")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("completion")
		end,
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			automatic_installation = true,
		},
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		opts = {
			ensure_installed = nil,
			automatic_installation = true,
			automatic_setup = true,
		},
	},
	"hrsh7th/cmp-vsnip",
	"hrsh7th/vim-vsnip",
	"hrsh7th/vim-vsnip-integ",
	"rafamadriz/friendly-snippets",
	{
		"folke/neodev.nvim",
		config = true,
	},
	"hrsh7th/cmp-nvim-lsp-signature-help",
	{
		"kosayoda/nvim-lightbulb",
		opts = {
			sign = {
				enabled = false,
			},
			virtual_text = {
				enabled = true,
				text = " ",
			},
			autocmd = { enabled = true },
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = function()
			local null_ls = require("null-ls")
			return {
				sources = {
					null_ls.builtins.formatting.prettierd.with({
						extra_filetypes = { "svelte" },
					}),
					null_ls.builtins.formatting.stylua,
				},
			}
		end,
	},
	-- Snippets
	"fivethree-team/vscode-svelte-snippets",
	-- Various FileType support
	"mattn/emmet-vim",
	"liuchengxu/vista.vim",
	"Freedzone/kerbovim",
	"maxbane/vim-asm_ca65",
	{
		"OmniSharp/omnisharp-vim",
		config = function()
			vim.g.OmniSharp_highlighting = 3
			vim.g.OmniSharp_typeLookupInPreview = 1
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = {
					enable = true,
					disable = { "c_sharp" },
				},
				context_commentstring = { -- JoosepAlviste/nvim-ts-context-commentstring
					enable = true,
				},
				autotag = { -- windwp/nvim-ts-autotag
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@call.outer",
							["if"] = "@call.inner",
							["aF"] = "@function.outer",
							["iF"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
	"tpope/vim-markdown",
	"clktmr/vim-gdscript3",
	"rubixninja314/vim-mcfunction",
	"rafcamlet/nvim-luapad",
	-- Visual changes
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			yadm = {
				enable = true,
			},
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		main = "colorizer",
		opts = {
			user_default_options = {
				mode = "virtualtext",
				css = true,
			},
		},
	},
	{
		dir = "~/Code/Lua/feline.nvim",
		dependencies = "jcdickinson/wpm.nvim",
		config = function()
			require("new_statusline")
		end,
	},
	{
		"goolord/alpha-nvim",
		main = "alpha",
		opts = function()
			return require("dashboard").config
		end,
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
	},
	"junegunn/goyo.vim",
	{
		"noib3/nvim-cokeline",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			return require("buffline")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			buftype_exclude = { "terminal", "help" },
			filetype_exclude = { "alpha" },
			char = "│",
			use_treesitter = true,
			show_current_context = true,
			context_patterns = {
				"function",
				"class",
				"method",
				"namespace",
				"^using",
				"^for",
				"^if",
				"^else",
				"^table",
				"^dictionary",
				"^list",
				"^while",
				"^try",
				"^except",
				"^finally",
				"^handler",
				"^finalizer",
				"^alternative",
				"^switch",
				"case",
			},
		},
	},
	"stevearc/dressing.nvim",
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true,     -- use a classic bottom cmdline for search
				command_palette = true,   -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false,       -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false,   -- add a border to hover docs and signature help
			},
		},
	},
	-- Nyooom!
	{
		"tweekmonster/startuptime.vim",
		cmd = "StartupTime",
	},
	-- I don't know where to put this one lol
	{
		"andweeb/presence.nvim",
		config = function()
			require("presence"):setup({
				buttons = false,
			})
		end,
	},
	{
		"jcdickinson/wpm.nvim",
		config = true,
	},
})
