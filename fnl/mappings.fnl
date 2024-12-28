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
(map! [n] "-" (. (require :oil) :open))

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
