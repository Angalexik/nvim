" mfussenegger/nvim-dap
command DapRepl lua require'dap'.repl.open()
command DapUp lua require'dap'.up()
command DapDown lua require'dap'.down()
command -nargs=* DapGoto lua require'dap'.goto_(<f-args>)
