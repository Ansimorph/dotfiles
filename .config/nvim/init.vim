" Load shared config
source /Users/bg/.config/nvim/shared.vim

call plug#begin('~/.config/nvim/plugged')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'shaunsingh/nord.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'prettier/vim-prettier', {
    \ 'do': 'yarn install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
  Plug 'chrisbra/vim-commentary'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'windwp/nvim-autopairs'
  Plug 'mattn/emmet-vim'
  Plug 'svermeulen/vim-subversive'
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'vuki656/package-info.nvim'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/cmp-nvim-lsp'
call plug#end()

" General settings
set number
set colorcolumn=81
set signcolumn=number
set termguicolors
set autowriteall

" Theme
let g:nord_borders = v:true
colorscheme nord

" Use ESC to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>

" Start terminal in insert mode
augroup terminal
  au TermOpen * startinsert
augroup END

" PLUGINS

" Telescope
nnoremap <C-p> <cmd> Telescope find_files<CR>
nnoremap <C-a> <cmd> Telescope buffers<CR>
nnoremap <C-f> <cmd> Telescope live_grep<CR>
nnoremap <C-i> <C-^>

" Tree
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_follow = 1
nnoremap <C-b> :NvimTreeToggle<CR>

" Prettier
let g:prettier#autoformat_config_present = 1
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

lua << EOF

--- LSP
require('lspsaga').init_lsp_saga()
lspconfig = require'lspconfig'

require'lspinstall'.setup()
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  lspconfig[server].setup{}
end

--- CMP
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  },

  mapping = {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  sources = {
    { name = 'buffer' },
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
  },
}

--- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

--- Package info
require('package-info').setup()

--- Autopair
require('nvim-autopairs').setup{}

--- Git Signs
require('gitsigns').setup()

--- Lualine
require("lualine").setup{
  options = {theme = 'nord'},
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {{'diagnostics', sources = {'nvim_lsp'}}},
    lualine_d = {'filename'},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
    },
  extensions = {'quickfix', 'nvim-tree'}
}
EOF

" Completion setup
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" LSP keys
nnoremap <silent> gr <cmd>lua require('lspsaga.rename').rename()<CR>
nnoremap <silent> gd :Lspsaga preview_definition<CR>
nnoremap <silent> ga :Lspsaga code_action<CR>
vnoremap <silent> ga :<C-U>Lspsaga range_code_action<CR>

