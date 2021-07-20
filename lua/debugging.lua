local dap = require"dap"
local dap_install = require"dap-install"

local dbgpath = require"dap-install.config".options["installation_path"]
local debuggers = vim.split(vim.fn.globpath(dbgpath, "*"), "\n")

for _, debugger in ipairs(debuggers) do
  local dbg = debugger:match("^.+/(.+)$"):gsub("/", "")
  dap_install.config(dbg, {})
end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= "" then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, "Please provide a port number")
      return val
    end,
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end
