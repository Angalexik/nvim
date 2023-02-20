" change leader to space
let mapleader = ' '
" fast save
map <leader>w <Cmd>w!<cr>
" fast search
map <leader><space> /
map <leader><C-space> ?
" exit terminal
tnoremap <esc> <C-\><C-N>
tnoremap <C-[> <C-\><C-N>
" go to diagnostic
nnoremap ]q <Cmd>lua vim.diagnostic.goto_next()<cr>
nnoremap [q <Cmd>lua vim.diagnostic.goto_prev()<cr>

" go to hunk
nnoremap ]g <Cmd>Gitsigns next_hunk<cr>
nnoremap [g <Cmd>Gitsigns prev_hunk<cr>

" barbar mappings
" Move to previous/next
nnoremap 		 <A-,> <Plug>(cokeline-focus-prev)
nnoremap 		 <A-.> <Plug>(cokeline-focus-next)
" Re-order to previous/next
" nnoremap 		 <A-<> <Cmd>BufferMovePrevious<CR>
" nnoremap 		 <A->> <Cmd>BufferMoveNext<CR>
" Goto buffer in position...
nnoremap 		 <A-1> <Plug>(cokeline-focus-1)
nnoremap 		 <A-2> <Plug>(cokeline-focus-2)
nnoremap 		 <A-3> <Plug>(cokeline-focus-3)
nnoremap 		 <A-4> <Plug>(cokeline-focus-4)
nnoremap 		 <A-5> <Plug>(cokeline-focus-5)
nnoremap 		 <A-6> <Plug>(cokeline-focus-6)
nnoremap 		 <A-7> <Plug>(cokeline-focus-7)
nnoremap 		 <A-8> <Plug>(cokeline-focus-8)
nnoremap 		 <A-9> <Plug>(cokeline-focus-9)
" Close buffer
nnoremap 		 <A-c> <Cmd>Bdelete<CR>
" Magic buffer-picking mode
nnoremap  <C-s>   <Plug>(cokeline-pick-focus)

" Open oil.nvim
nnoremap - <Cmd>lua require("oil").open()<cr>
