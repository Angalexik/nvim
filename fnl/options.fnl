(import-macros {: set!} :macros)

(set! mouse :a) ; enable mouse
(set! encoding :utf-8) ; change encoding to utf8
(set! relativenumber) ; show numbers relative to cursor position
(set! number) ; show current line number
(set! breakindent) ; broken lines have the same indentation
(set! termguicolors) ; ALL the colours
(set! noshowmode) ; dont show the current mode in cmdline
(set! signcolumn "yes:1") ; always show signcolumn with a width of 1
(set! scrolloff 2) ; always show 2 lines above or below the cursor
(set! hidden) ; keep buffers after abandoning
(set! ignorecase) ; make things case insensitive
(set! smartcase) ; make things case sensitive if there is a capital letter
(set! clipboard :unnamedplus) ; synchronise vim clipboard with system clipboard
(set! tabstop 2) ; 2 wide tabs
(set! shiftwidth 2)
(set! updatetime 300) ; speed up cursorhold
(set! completeopt ["menuone" "noselect"]) ; show menu even if there is only completion and don't automatically select
(set! path "**") ; magic fuzzy finding
(set! fillchars {"eob" " " "fold" " "}) ; remove ~ at the end of file, remove · after folds
(set! list)
(set! listchars {"trail" "·" "nbsp" "␣" "tab" "  "}) ; show trailing whitespace as `·` and NBSP as `␣`
; treesitter folding
(set! foldmethod :expr)
(set! foldexpr "nvim_treesitter#foldexpr()")
(set! foldlevel 99) ; don't automatically close folds
(set! foldtext asdf)
(set! foldtext #(let [line (vim.fn.getline vim.v.foldstart)
                      folded-line-count (+ (- vim.v.foldend vim.v.foldstart) 1)]
                  (.. "  " folded-line-count " lines " line)))
(set! guifont "monolisa_nerd_font:h13.6")
