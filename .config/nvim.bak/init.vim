" Stop powerline (that I use in fish) from fucking up neovim
let g:powerline_loaded = 1

syntax on
set shell=/usr/bin/bash
" Partially stolen config from ThePrimeagen's config https://github.com/erkrnt/awesome-streamerrc/blob/master/ThePrimeagen/init.vim
set guicursor=
"set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
"set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.nvim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set wildmode=list:longest
" Give more space for displaying messages.
set cmdheight=2
"set mouse=a
set clipboard^=unnamedplus
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

call plug#begin()
Plug 'gkapfham/vim-vitamin-onec'                    " colour scheme
Plug 'sainnhe/sonokai'                              " colour scheme
Plug 'mbbill/undotree'                              " undo tree - press leader-u
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fuzzy finder - :Files and friends
Plug 'junegunn/fzf.vim'
Plug 'ThePrimeagen/vim-be-good'                     " jumping training game
Plug 'airblade/vim-rooter'                          " finds project root by looking for a .git folder
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'                              " file viewer tree - press leader-t
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " syntax-aware multi-language code parser
"LSP plugins
"Plug 'nvim-lua/completion-nvim'
"Plug 'neovim/nvim-lspconfig'
call plug#end()

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

let mapleader = " "

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>= :wincmd =<CR>
nnoremap <leader>o :wincmd o<CR>

nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>t :NvimTreeToggle<CR>

"paste over selected text. (Delete selection and dump it in the black hole
"register)
vnoremap <leader>p "_dP

"Quick way to exit insert mode
inoremap jk <Esc>
inoremap kj <Esc>
"These should do the same thing, but working properly with relative line jumps
"(like 10j). Unfortunately they only work in Vim. I can't figure out how to
"make them work in Neovim.
"noremap <expr> j (v:count? 'j' : 'gj')
"noremap <expr> k (v:count? 'k' : 'gk')

"Move up and down wrapped lines like a normal text editor
nnoremap j gj
nnoremap k gk

"Move between buffers
nnoremap <S-l> :bn<CR>
nnoremap <S-h> :bp<CR>

" "Drag" a line of text up or down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

let g:sonokai_transparent_background = 1
" Display the colorscheme
colorscheme sonokai 

" Flash selection when it's yanked
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

" Configuration for NvimTree is written in lua
lua << EOF
-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
-- require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
EOF


lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF


