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
"LSP plugins
Plug 'nvim-lua/completion-nvim'
Plug 'neovim/nvim-lspconfig'
call plug#end()

lua <<EOF
require'nvim_lsp'.clangd.setup{}
EOF

lua <<EOF
require'nvim_lsp'.jedi_language_server.setup{}
EOF

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
lua require'nvim_lsp'.clangd.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.jedi_language_server.setup{ on_attach=require'completion'.on_attach }
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
let g:sonokai_transparent_background = 1

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>= :wincmd =<CR>
nnoremap <leader>o :wincmd o<CR>

nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>f :Files<CR>
"paste over selected text. (Delete selection and dump it in the black hole
"register)
vnoremap <leader>p "_dP

inoremap jk <Esc>
inoremap kj <Esc>

" Display the colorscheme
colorscheme sonokai 

" Flash selection when it's yanked
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END
