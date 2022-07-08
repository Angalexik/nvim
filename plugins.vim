call plug#begin(stdpath('data') . '/plugins')

" Plugin dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'Olical/aniseed'

" Colour scheme
Plug 'arcticicestudio/nord-vim'

" QOL
Plug 'lilydjwg/fcitx.vim'
Plug 'eraserhd/parinfer-rust', { 'do': 'cargo build --release' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'Angalexik/vim-sleuth'
Plug 'tpope/vim-sensible'
Plug 'justinmk/vim-dirvish'
Plug 'editorconfig/editorconfig-vim'
Plug 'ahmedkhalf/project.nvim'
Plug 'ggandor/lightspeed.nvim'
Plug 'windwp/nvim-ts-autotag', { 'for': ['html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'xml', 'php', 'glimmer', 'handlebars', 'hbs'] }
Plug 'windwp/nvim-autopairs'
Plug 'nvim-telescope/telescope.nvim'
Plug 'yuttie/comfortable-motion.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Completion/LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'folke/lua-dev.nvim'
Plug 'mfussenegger/nvim-lint'

" Snippets
Plug 'fivethree-team/vscode-svelte-snippets', { 'for': 'svelte' }

" Various FileType support
Plug 'mattn/emmet-vim', { 'for': ['svelte', 'html', 'xml'] }
Plug 'liuchengxu/vista.vim', { 'on': ['Vista', 'Vista!!'] }
Plug 'digitaltoad/vim-pug'
Plug 'Freedzone/kerbovim'
Plug 'maxbane/vim-asm_ca65'
Plug 'OmniSharp/omnisharp-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'tpope/vim-markdown'
Plug 'clktmr/vim-gdscript3'
Plug 'rubixninja314/vim-mcfunction'
Plug 'neoclide/npm.nvim', {'do': 'npm install'}
Plug 'rafcamlet/nvim-luapad', { 'on': ['Luapad', 'LuaRun', 'Lua'] }

" Visual changes
Plug 'lewis6991/gitsigns.nvim'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'famiu/feline.nvim'
Plug 'goolord/alpha-nvim'
Plug 'junegunn/goyo.vim'
Plug 'romgrk/barbar.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

" Auto install
autocmd VimEnter *
	\  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\|	 PlugInstall --sync | q
	\| endif
