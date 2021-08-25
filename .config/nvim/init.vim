" Load shared config
source /Users/bg/.config/nvim/shared.vim

lua << EOF

--- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)

local use = require('packer').use
require('packer').startup(function()
  use 'shaunsingh/nord.nvim'
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'prettier/vim-prettier', run = 'yarn install' } 
  use 'chrisbra/vim-commentary'
  use 'editorconfig/editorconfig-vim'
  use 'hoob3rt/lualine.nvim'
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
  use 'windwp/nvim-autopairs'
  use 'mattn/emmet-vim'
  use 'svermeulen/vim-subversive'
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'
  use 'glepnir/lspsaga.nvim'
  use 'kyazdani42/nvim-tree.lua'
  use 'vuki656/package-info.nvim'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-nvim-lsp'
end)

EOF

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require'lspinstall'.setup()
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  lspconfig[server].setup{
    capabilities = capabilities,
  }
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
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
  },
}

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. "c"

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

" LSP keys
nnoremap <silent> gr <cmd>lua require('lspsaga.rename').rename()<CR>
nnoremap <silent> gd :Lspsaga preview_definition<CR>
nnoremap <silent> ga :Lspsaga code_action<CR>
vnoremap <silent> ga :<C-U>Lspsaga range_code_action<CR>

