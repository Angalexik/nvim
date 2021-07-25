" change leader to space
let mapleader = ' '
" fast save
map <leader>w :w!<cr>
" fast search
map <leader><space> /
map <leader><C-space> ?
" exit terminal
tnoremap <esc> <C-\><C-N>

" dap mappings
" step over
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
" step in
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
" step out
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
" disconnect
nnoremap <silent> <F3> :lua require'dap'.disconnect()<CR>
" continue
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
" pause
nnoremap <silent> <F6> :lua require'dap'.pause()<CR>
" breakpoint
nnoremap <silent> <F9> :lua require'dap'.toggle_breakpoint()<CR>

" barbar mappings
" Move to previous/next
nnoremap <silent>		 <A-,> :BufferPrevious<CR>
nnoremap <silent>		 <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>		 <A-<> :BufferMovePrevious<CR>
nnoremap <silent>		 <A->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>		 <A-1> :BufferGoto 1<CR>
nnoremap <silent>		 <A-2> :BufferGoto 2<CR>
nnoremap <silent>		 <A-3> :BufferGoto 3<CR>
nnoremap <silent>		 <A-4> :BufferGoto 4<CR>
nnoremap <silent>		 <A-5> :BufferGoto 5<CR>
nnoremap <silent>		 <A-6> :BufferGoto 6<CR>
nnoremap <silent>		 <A-7> :BufferGoto 7<CR>
nnoremap <silent>		 <A-8> :BufferGoto 8<CR>
nnoremap <silent>		 <A-9> :BufferLast<CR>
" Close buffer
nnoremap <silent>		 <A-c> :BufferClose<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-s>		 :BufferPick<CR>

" compe mappings
imap <expr> <Tab> v:lua.tab_complete()
smap <expr> <Tab> v:lua.tab_complete()
imap <expr> <S-Tab> v:lua.s_tab_complete()
smap <expr> <S-Tab> v:lua.s_tab_complete()

" change to writing mode
" TODO: fix this
nmap <leader>zz :source ~/.config/nvim/markdown.vim<cr>