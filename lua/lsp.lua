local M = {}

M.auto_installed_servers = {
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
	"yamlls",
	"gopls",
	"fsautocomplete",
	"ocamllsp",
}

local servers = {
	"kls",
	"gdscript",
}
vim.list_extend(servers, M.auto_installed_servers)

function M.setup()
	vim.diagnostic.config({
		float = { source = true },
		virtual_text = { prefix = "●", source = true },
	})

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	vim.lsp.config("*", {
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
		on_attach = function(_, _)
			vim.cmd('echo serverstart("/tmp/godot.pipe")')
		end,
	})

	vim.lsp.enable(servers)
end

return M
