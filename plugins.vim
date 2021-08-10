call plug#begin(stdpath('data') . '/plugins')

" Plugin dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Colour scheme
Plug 'Angalexik/nord-vim'
Plug 'dracula/vim'
Plug 'reedes/vim-colors-pencil'

" QOL
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'Angalexik/vim-sleuth'
Plug 'tpope/vim-sensible'
Plug 'justinmk/vim-dirvish'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-rooter'
Plug 'ggandor/lightspeed.nvim'
Plug 'windwp/nvim-ts-autotag', { 'for': ['html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'xml', 'php', 'glimmer', 'handlebars', 'hbs'] }
Plug 'windwp/nvim-autopairs'
Plug 'nvim-telescope/telescope.nvim', { 'on': 'Telescope' }
Plug 'yuttie/comfortable-motion.vim'
Plug 'jbyuki/one-small-step-for-vimkind'

" Completion/LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'onsails/lspkind-nvim'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'folke/lua-dev.nvim'
Plug 'mfussenegger/nvim-lint'

" Snippets
Plug 'fivethree-team/vscode-svelte-snippets', { 'for': 'svelte' }

" Various FileType support
Plug 'Pocco81/DAPInstall.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'mattn/emmet-vim', { 'for': ['svelte', 'html', 'xml'] }
Plug 'evanleck/vim-svelte'
Plug 'liuchengxu/vista.vim', { 'on': ['Vista', 'Vista!!'] }
Plug 'digitaltoad/vim-pug'
Plug 'Freedzone/kerbovim'
Plug 'maxbane/vim-asm_ca65'
Plug 'OmniSharp/omnisharp-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'on': ['MarkdownPreview', 'MarkdownPreviewToggle'] }
Plug 'tpope/vim-markdown'
Plug 'clktmr/vim-gdscript3'
Plug 'rubixninja314/vim-mcfunction'
Plug 'neoclide/npm.nvim', {'do': 'npm install'}
Plug 'rafcamlet/nvim-luapad', { 'on': ['Luapad', 'LuaRun', 'Lua'] }

" Visual changes
Plug 'lewis6991/gitsigns.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'glepnir/galaxyline.nvim'
Plug 'mhinz/vim-startify'
Plug 'junegunn/goyo.vim'
Plug 'romgrk/barbar.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

" Auto install
autocmd VimEnter *
	\  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\|	 PlugInstall --sync | q
	\| endif
