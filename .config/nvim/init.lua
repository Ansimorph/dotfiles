-- Load shared config
require 'shared-config'

-- Install packer
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
  use 'wbthomason/packer.nvim'
  use 'shaunsingh/nord.nvim'
  use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'chrisbra/vim-commentary'
  use 'editorconfig/editorconfig-vim'
  use 'nvim-lualine/lualine.nvim'
  use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'windwp/nvim-autopairs'
  use 'mattn/emmet-vim'
  use 'svermeulen/vim-subversive'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'kyazdani42/nvim-tree.lua'
  use { 'vuki656/package-info.nvim', requires = 'MunifTanjim/nui.nvim' }
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'norcalli/nvim-colorizer.lua'
  use 'jose-elias-alvarez/null-ls.nvim'
end)

-- Save when switching buffers
vim.o.autowriteall = true
-- Make line numbers default
vim.wo.number = true
-- Add line width marker
vim.o.colorcolumn = '81'
-- Show signs in the number column
vim.wo.signcolumn = 'number'

-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

-- Start terminal in insert mode
vim.api.nvim_exec(
  [[
  augroup terminal
    au TermOpen * startinsert
  augroup END
]],
  false
)

-- Use ESC to exit insert mode in :term
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Theme
vim.o.termguicolors = true
vim.g.nord_borders = true
vim.cmd [[colorscheme nord]]

-- PLUGINS

-- Telescope
vim.api.nvim_set_keymap('n', '<C-p>', '<Cmd> Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', '<Cmd> Telescope live_grep<CR>', { noremap = true })

-- Tree
vim.g.nvim_tree_quit_on_open = 1
require('nvim-tree').setup {
  update_focused_file = {
    enable = true,
  },
}
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true })

-- LSP
lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require('nvim-lsp-installer').on_server_ready(function(server)
  server:setup {
    capabilities = capabilities,
    on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end,
  }
  vim.cmd [[ do User LspAttachBuffers ]]
end)

vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'ga', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ge', '<Cmd>:lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })

-- Null-LS
require('null-ls').config {
  sources = {
    -- Formatters
    require('null-ls').builtins.formatting.prettierd,
    require('null-ls').builtins.formatting.stylua,
  },
}

lspconfig['null-ls'].setup {
  -- Format on save
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
    end
  end,
}

-- CMP
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  mapping = {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
  },

  sources = {
    { name = 'path' },
    { name = 'buffer' },
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
  },
}

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Package info
require('package-info').setup()

-- Autopair
require('nvim-autopairs').setup()

require('nvim-autopairs.completion.cmp').setup {
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = true, -- automatically select the first item
}

-- Git Signs
require('gitsigns').setup()

-- Lualine
require('lualine').setup {
  options = { theme = 'nord' },
  sections = {
    lualine_a = { { 'mode' } },
    lualine_b = { { 'filename', file_status = true } },
    lualine_c = { { 'diagnostics', sources = { 'nvim_lsp' } } },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { { 'branch', icon = '' } },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'quickfix', 'nvim-tree' },
}

-- Colorizer
require('colorizer').setup {
  css = { rgb_fn = true },
  scss = { rgb_fn = true },
  sass = { rgb_fn = true },
  stylus = { rgb_fn = true },
  vim = { names = false },
  tmux = { names = false },
}
