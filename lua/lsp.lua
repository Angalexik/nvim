vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = {prefix = "●"}})

local lspinstall = require('lspinstall')
local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')

-- Install python-lsp-server
local pylspconfig = require('lspinstall/util').extract_config("pylsp")
pylspconfig.default_config.cmd[1] = "./venv/bin/pylsp"
require("lspinstall/servers").pylsp = vim.tbl_extend('error', pylspconfig, {
  install_script = [[
  python3 -m venv ./venv
  ./venv/bin/pip3 install -U pip
  ./venv/bin/pip3 install -U 'python-lsp-server[all]'
  ./venv/bin/pip3 install -U pylsp-mypy
  ]]
})

lspinstall.setup()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = {noremap = true, silent = true}

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


local function has_value (tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "csharp", "svelte", "bash", "json", "html", "typescript", "cpp", "vim", "css", "lua", "pylsp" }
local installed_servers = lspinstall.installed_servers()
for _, server in ipairs(servers) do
  if not has_value(installed_servers, server) then
    lspinstall.install_server(server)
  end
end

for _, lsp in ipairs(installed_servers) do
  if lsp == "lua" then
    local luadev = require("lua-dev").setup({ lspconfig = { on_attach = on_attach } })
    luadev.settings.Lua.workspace.library = {"/home/alex/Python/ldoctoemmy/libs",}
    nvim_lsp[lsp].setup(luadev)
  else
    nvim_lsp[lsp].setup {on_attach = on_attach}
  end
end

-- nvim_lsp.kls.setup {on_attach = on_attach}

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

lint.linters.eslint = function ()
  local severities = {
    ["1"] = vim.lsp.protocol.DiagnosticSeverity.Warning,
    ["2"] = vim.lsp.protocol.DiagnosticSeverity.Error,
  }
  return {
    cmd = "eslint_d",
    stdin = true,
    args = {
      "-f",
      "json",
      "--stdin",
      "--stdin-filename",
      vim.fn.expand("%"),
    },
    stream = "stdout",
    ignore_exitcode = true,
    parser = function(output)
      --- @class ESLintOutput
      --- @field filePath string
      --- @field messages table<number, ESLintMessage>
      --- @field errorCount number
      --- @field warningCount number
      --- @field fixableErrorCount number
      --- @field fixableWarningCount number
      --- @field source string

      --- @class ESLintMessage
      --- @field ruleId string
      --- @field severity number
      --- @field message string
      --- @field line number
      --- @field column number
      --- @field nodeType string
      --- @field messageId string
      --- @field endLine number
      --- @field endColumn number

      --- @type ESLintOutput
      local decoded = {}
      if pcall(vim.fn.json_decode, output) then
        decoded = vim.fn.json_decode(output)[1]
      else
        decoded = {
          messages = {
            {
              line = 1,
              column = 1,
              message = "ESLint error, run `eslint " .. vim.fn.expand("%") .. "` for more info.",
              severity = 2,
              ruleId = "none",
            },
          }
        }
      end
      local diagnostics = {}
      for _, message in ipairs(decoded.messages) do
        if not message.endLine then
          message.endLine = message.line
        end
        if not message.endColumn then
          message.endColumn = message.column
        end
        table.insert(diagnostics, {
          range = {
            start = {
              line = message.line - 1,
              character = message.column - 1,
            },
            ["end"] = {
              line = message.endLine - 1,
              character = message.endColumn - 1,
            },
          },
          message = message.message,
          code = message.ruleId,
          source = "eslint",
          severity = severities[message.severity],
        })
      end
      return diagnostics
    end
  }
end

lint.linters.stylelint = function ()
  local severities = {
    warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
    error = vim.lsp.protocol.DiagnosticSeverity.Error,
  }
  return {
    cmd = "stylelint",
    stdin = true,
    args = {
      "-f",
      "json",
      "--stdin",
      "--stdin-filename",
      vim.fn.expand("%"),
    },
    stream = "stdout",
    ignore_exitcode = true,
    parser = function (output)
      --- @class StylelintOutput
      --- @field source string
      --- @field deprecations table
      --- @field invalidOptionWarnings table
      --- @field parseErrors table
      --- @field errored boolean
      --- @field warnings table<number, StylelintMessage>

      --- @class StylelintMessage
      --- @field line number
      --- @field column number
      --- @field rule string
      --- @field severity string
      --- @field text string

      --- @type StylelintOutput
      local decoded = {}
      if pcall(vim.fn.json_decode, output) then
        decoded = vim.fn.json_decode(output)[1]
      else
        decoded = {
          warnings = {
            {
              line = 1,
              column = 1,
              text = "Stylelint error, run `stylelint " .. vim.fn.expand("%") .. "` for more info.",
              severity = "error",
              rule = "none",
            },
          },
          errored = true,
        }
      end
      local diagnostics = {}
      if decoded.errored then
        for _, message in ipairs(decoded.warnings) do
          table.insert(diagnostics, {
            range = {
              start = {
                line = message.line - 1,
                character = message.column - 1,
              },
              ["end"] = {
                line = message.line - 1,
                character = message.column,
              },
            },
            message = message.text,
            code = message.rule,
            severity = severities[message.severity],
            source = "stylelint",
          })
        end
      end
      return diagnostics
    end
  }
end

lint.linters_by_ft = {
  svelte = {"eslint", "stylelint"},
  javascript = {"eslint",},
  typescript = {"eslint",},
  javascriptreact = {"eslint",},
  typescriptreact = {"eslint",},
  css = {"stylelint"},
  scss = {"stylelint"},
  sass = {"stylelint"}
}
-- lint.try_lint()
vim.api.nvim_command("autocmd InsertLeave,BufEnter,TextChanged <buffer> lua require('lint').try_lint()")
