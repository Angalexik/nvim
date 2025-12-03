(import-macros {: map!} :macros)

; change leader to space
(set vim.g.mapleader " ")

; fast save
(map! [n] "<leader>w" "<cmd>w!<cr>")
; fast search
(map! [n] "<leader><space>" "/")
; exit insert in terminal
(map! [t] "<esc>" "<c-\\><c-n>")
(map! [t] "<c-[>" "<c-\\><c-n>")

; go to diagnostic
(map! [n] "]q" vim.diagnostic.goto_next)
(map! [n] "[q" vim.diagnostic.goto_prev)

; go to hunk
(map! [n] "]g" "<cmd>Gitsigns next_hunk<cr>")
(map! [n] "[g" "<cmd>Gitsigns prev_hunk<cr>")

; cokeline mappings
; Move to previous/next
(map! [n] "<a-,>" "<plug>(cokeline-focus-prev)")
(map! [n] "<a-.>" "<plug>(cokeline-focus-next)")
; Close buffer
(map! [n] "<a-c>" "<cmd>Bdelete<cr>")
; Magic buffer-picking mode
(map! [n] "<c-s>" "<plug>(cokeline-pick-focus)")

; open oil.nvim
(map! [n] "-" #((. (require :oil) :open)))
; formatting
(map! [n] "<leader>f"
      #((. (require :conform) :format) {:async true :lsp_fallback true}))

; open floating lazygit (mnemonic Git Lazy)
(map! [n] "gl" "<cmd>Lazygit<cr>")

; Telescope
; Mnemonics: <leader>s for telescope and <key> as the telescope version of
; what it does normally)
(map! [n] "<leader>s/" "<cmd>Telescope live_grep<cr>")
(map! [n] "<leader>s#" "<cmd>Telescope grep_string<cr>")
(map! [n] "<leader>s*" "<cmd>Telescope grep_string<cr>")
(map! [n] "<leader>s-" "<cmd>Telescope find_files<cr>")
; Mnemonic: r for recent files)
(map! [n] "<leader>sr" "<cmd>Telescope oldfiles<cr>")

; Aerial.nvim
; Mnemonic: n for navigation
(map! [n] "<leader>n" "<cmd>AerialOpen float<cr>")

; Leap.nvim
(map! [n] "s"  "<plug>(leap-forward)")
(map! [n] "S"  "<plug>(leap-backward)")
(map! [xo] "z"  "<plug>(leap-forward)")
(map! [xo] "Z"  "<plug>(leap-backward)")
(map! [n]   "gs" "<plug>(leap-from-window)")
(map! [xo]  "x"  "<plug>(leap-forward-till)")
(map! [xo]  "X"  "<plug>(leap-backward-till)")

; Lsp
(vim.api.nvim_create_autocmd
  :LspAttach
  {:callback
   #(do
     (vim.cmd "autocmd InsertLeave,BufEnter,TextChanged <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })")
     (map! [n :buffer] "gD" vim.lsp.buf.declaration)
     (map! [n :buffer] "gd" vim.lsp.buf.definition)
     (map! [n :buffer] "gy" vim.lsp.buf.type_definition)
     (map! [n :buffer] "gr" "<cmd>Telescope lsp_references<cr>")
     (map! [n :buffer] "K" vim.lsp.buf.hover)
     (map! [n :buffer] "gi" vim.lsp.buf.implementation)
     (map! [n :buffer] "<leader>rn" vim.lsp.buf.rename)
     (map! [n :buffer] "<leader>ca" vim.lsp.buf.code_action))})
