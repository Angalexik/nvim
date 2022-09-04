vim.lsp.handlers["textDocument/publishDiagnostics"] =
	vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = { prefix = "●" } })

local lspconfig = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	if client.server_capabilities.codeLensProvider then
		vim.api.nvim_command("autocmd InsertLeave,BufEnter,TextChanged <buffer> lua vim.lsp.codelens.refresh()")
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- vim.api.nvim_command("autocmd CursorHold * silent lua vim.lsp.buf.hover({focuasble=false})")
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
	buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
	"omnisharp",
	"svelte",
	"bashls",
	"jsonls",
	"html",
	"tsserver",
	"clangd",
	"vimls",
	"cssls",
	"sumneko_lua",
	"pylsp",
	"rust_analyzer",
	"eslint",
	"tailwindcss",
}

local luadev = require("lua-dev").setup({
	lspconfig = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
})

require("mason").setup({})
require("mason-lspconfig").setup({
	automatic_installation = true,
})

for _, server in ipairs(servers) do
	if server == "sumneko_lua" then
		lspconfig.sumneko_lua.setup(luadev)
	else
		lspconfig[server].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end
end

local nullls = require("null-ls")

nullls.setup({
	sources = {
		nullls.builtins.formatting.prettierd.with({
			extra_filetypes = { "svelte" },
		}),
		nullls.builtins.formatting.stylua,
	},
})

local lint = require("lint")

lint.linters_by_ft = {
	svelte = { "stylelint" },
	css = { "stylelint" },
	scss = { "stylelint" },
	sass = { "stylelint" },
	sh = { "shellcheck" },
	bash = { "shellcheck" },
}

require("nvim-lightbulb").setup({
	sign = {
		enabled = false,
	},
	virtual_text = {
		enabled = true,
		text = "ﯦ ",
	},
})

vim.api.nvim_command('autocmd CursorHold,CursorHoldI * lua require("nvim-lightbulb").update_lightbulb()')
-- vim.api.nvim_command("autocmd InsertLeave,BufEnter,TextChanged,BufWritePost <buffer> lua require('lint').try_lint()")
