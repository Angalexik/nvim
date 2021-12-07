vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = {prefix = "●"}})

local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')
local lsp_installer = require('nvim-lsp-installer')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = {noremap = true, silent = true}

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_command("autocmd InsertLeave,BufEnter,TextChanged <buffer> lua vim.lsp.codelens.refresh()")
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- vim.api.nvim_command("autocmd CursorHold * silent lua vim.lsp.buf.hover({focuasble=false})")
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>',
                 opts)
  buf_set_keymap('n', '<space>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)

end

configs.kls = {
  default_config = {
    cmd = {'kls', '--stdio'},
    filetypes = {'kerboscript'},
    root_dir = function(fname) return vim.fn.getcwd() end,
    settings = {}
  }
}

local luadev = require('lua-dev').setup({
  lspconfig = {
    on_attach = on_attach
  }
})

local servers = { "omnisharp", "svelte", "bashls", "jsonls", "html", "tsserver", "clangd", "vimls", "cssls", "sumneko_lua", "pylsp", "rust_analyzer", "eslint" }
local lsp_installer_servers = require('nvim-lsp-installer.servers')
local to_install = {}
for _, server in ipairs(servers) do
  if not lsp_installer_servers.is_server_installed(server) then
    table.insert(to_install, server)
  end
end

if #to_install ~= 0 then
  lsp_installer.install_sync(to_install)
end

lsp_installer.on_server_ready(function (server)
  local opts = { on_attach = on_attach }
  if server.name == "sumneko_lua" then
    opts = luadev
  end
  server:setup(opts)
end)

require('lspkind').init({
  symbol_map = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Variable = '',
    Class = 'פּ',
    Interface = 'ﰮ',
    Module = '',
    Property = '襁',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = ''
  }
})

local lint = require("lint")

lint.linters_by_ft = {
  svelte = {"stylelint"},
  css = {"stylelint"},
  scss = {"stylelint"},
  sass = {"stylelint"},
  sh = {"shellcheck"},
  bash = {"shellcheck"},
}

vim.api.nvim_command("autocmd InsertLeave,BufEnter,TextChanged,BufWritePost <buffer> lua require('lint').try_lint()")
