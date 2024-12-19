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
	{
		"eraserhd/parinfer-rust",
		build = "cargo build --release",
		enabled = function()
			return vim.fn.executable("cargo") == 1
		end,
	},
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
	{ "psliwka/vim-smoothie", enabled = not vim.g.neovide },
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
	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	"wincent/ferret",
	{
		"jedrzejboczar/exrc.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			on_dir_changed = {
				enabled = true,
				use_ui_select = false,
			},
		},
	},
	-- Completion/LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			"mason.nvim",
		},
		config = function()
			require("lsp")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		commit = "b356f2c",
		pin = true,
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
	"hrsh7th/cmp-vsnip",
	"hrsh7th/vim-vsnip",
	"hrsh7th/vim-vsnip-integ",
	"rafamadriz/friendly-snippets",
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
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			---@diagnostic disable-next-line: missing-fields
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "n",
			},
		},
		opts = {
			formatters_by_ft = {
				python = { "black" },
				lua = { "stylua" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				markdown = { "prettierd" },
				-- svelte = { "prettierd" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				typescript = { "eslint" },
				javascript = { "eslint" },
				svelte = { "eslint" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
				pattern = "*",
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
		opts = {},
		event = "VeryLazy",
	},
	{
		"github/copilot.vim",
		init = function()
			vim.g.copilot_no_tab_map = true
			-- Doesn't work with vim.keymap for some reason
			vim.cmd([[imap <silent><script><expr> <Plug>(accept-copilot) copilot#Accept()]])
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"Bilal2453/luvit-meta",
		lazy = true,
	},
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
	"JoosepAlviste/nvim-ts-context-commentstring",
	{
		"windwp/nvim-ts-autotag",
		opts = {
			opts = {
				enable_close = true,
				enable_rename = false,
				enable_close_on_slash = true,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = {
					enable = true,
					disable = { "c_sharp" },
				},
				matchup = {
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
	"isobit/vim-caddyfile",
	{
		"ionide/ionide-vim",
		lazy = true,
	},
	-- Visual changes
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"purarue/gitsigns-yadm.nvim",
				opts = { shell_timeout_ms = 1000 },
			},
		},
		opts = {
			_on_attach_pre = function(_, callback)
				require("gitsigns-yadm").yadm_signs(callback)
			end,
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
		"freddiehaddad/feline.nvim",
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
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			exclude = {
				filetypes = { "alpha" },
				buftypes = { "terminal", "help" },
			},
			scope = {
				highlight = { "Label" },
				show_end = false,
				include = {
					node_type = {
						python = { "for_statement", "if_statement", "while_statement" },
						css = { "media_statement", "rule_set" },
					},
				},
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
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
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
