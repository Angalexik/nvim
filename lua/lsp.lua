local M = {}

M.servers = {
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
	-- "kls",
	"yamlls",
	"gopls",
	"fsautocomplete",
	-- "gdscript",
	"ocamllsp",
}

function M.setup()
	vim.diagnostic.config({
		float = { source = true },
		virtual_text = { prefix = "●", source = true },
	})

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end

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

	vim.lsp.config("*", {
		on_attach = on_attach,
		capabilities = capabilities,
	})

	vim.lsp.config("kls", {
		cmd = { "/home/alex/Code/JS/kos-language-server/server/bin/kos", "--stdio" },
		filetypes = { "kerboscript" },
		root_dir = function(startpath)
			return vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
		end,
		settings = {},
	})

	vim.lsp.config("clangd", {
		capabilities = vim.tbl_deep_extend("keep", {
			offsetEncoding = "utf-16",
		}, capabilities),
		cmd = { "clangd", "--clang-tidy" },
	})

	vim.lsp.config("gdscript", {
		flags = { debounce_text_changes = 150 },
		on_attach = function(client, bufnr)
			vim.cmd('echo serverstart("/tmp/godot.pipe")')
			on_attach(client, bufnr)
		end,
	})

	for _, server in ipairs(M.servers) do
		vim.lsp.enable(server)
	end
end

return M
