" change leader to space
let mapleader = ' '
" fast save
map <leader>w <Cmd>w!<cr>
" fast search
map <leader><space> /
map <leader><C-space> ?
" exit terminal
tnoremap <esc> <C-\><C-N>
" go to diagnostic
nnoremap ]q <Cmd>lua vim.diagnostic.goto_next()<cr>
nnoremap [q <Cmd>lua vim.diagnostic.goto_prev()<cr>

" barbar mappings
" Move to previous/next
nnoremap 		 <A-,> <Cmd>BufferPrevious<CR>
nnoremap 		 <A-.> <Cmd>BufferNext<CR>
" Re-order to previous/next
nnoremap 		 <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap 		 <A->> <Cmd>BufferMoveNext<CR>
" Goto buffer in position...
nnoremap 		 <A-1> <Cmd>BufferGoto 1<CR>
nnoremap 		 <A-2> <Cmd>BufferGoto 2<CR>
nnoremap 		 <A-3> <Cmd>BufferGoto 3<CR>
nnoremap 		 <A-4> <Cmd>BufferGoto 4<CR>
nnoremap 		 <A-5> <Cmd>BufferGoto 5<CR>
nnoremap 		 <A-6> <Cmd>BufferGoto 6<CR>
nnoremap 		 <A-7> <Cmd>BufferGoto 7<CR>
nnoremap 		 <A-8> <Cmd>BufferGoto 8<CR>
nnoremap 		 <A-9> <Cmd>BufferLast<CR>
" Close buffer
nnoremap 		 <A-c> <Cmd>BufferClose<CR>
" Magic buffer-picking mode
nnoremap  <C-s>		 <Cmd>BufferPick<CR>
