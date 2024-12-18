vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics,
	{ virtual_text = { prefix = "●", source = "always" }, float = { source = "always" } }
)

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
	-- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
	buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
	"omnisharp",
	"svelte",
	"bashls",
	"jsonls",
	"html",
	"ts_ls",
	"clangd",
	"vimls",
	"cssls",
	"lua_ls",
	"basedpyright",
	"rust_analyzer",
	"tailwindcss",
	"kls",
	"yamlls",
	require("ionide"),
}

local config_overrides = {
	pylsp = {
		pylsp = {
			plugins = {
				pycodestyle = {
					-- Stop yelling when using black formatter
					ignore = { "E203", "W503" },
					maxLineLength = 88,
				},
			},
		},
	},
}

local configs = require("lspconfig.configs")

if not configs.kls then
	configs.kls = {
		default_config = {
			cmd = { "/home/alex/Code/JS/kos-language-server/server/bin/kos", "--stdio" },
			filetypes = { "kerboscript" },
			root_dir = function(fname)
				return lspconfig.util.find_git_ancestor(fname)
			end,
			settings = {},
		},
	}
end

local function setup(server, settings)
	local server_table = nil
	if type(server) == "string" then
		server_table = lspconfig[server]
	elseif type(server) == "table" then
		server_table = server
	elseif type(server) == "function" then
		setup(server())
		return
	else
		error("Server must be a string, table or function")
	end

	server_table.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		settings = settings,
	})
end

for _, server in ipairs(servers) do
	local settings = {}
	if config_overrides[server] ~= nil then
		settings = config_overrides[server]
	end

	if server == "clangd" then
		lspconfig[server].setup({
			on_attach = on_attach,
			capabilities = vim.tbl_deep_extend("keep", {
				offsetEncoding = "utf-16",
			}, capabilities),
			settings = settings,
			cmd = { "clangd", "--clang-tidy" },
		})
		goto continue
	end

	setup(server, settings)

	::continue::
end
