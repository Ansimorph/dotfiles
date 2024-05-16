-- Enable fast loader
vim.loader.enable()

require 'paq' {
  'savq/paq-nvim',
  'nvim-lua/plenary.nvim', -- required by telescope
  'MunifTanjim/nui.nvim', -- required by package info
  'gbprod/nord.nvim',
  'lewis6991/gitsigns.nvim',
  'nvim-lualine/lualine.nvim',
  'nvim-telescope/telescope.nvim',
  'm4xshen/autoclose.nvim',
  'windwp/nvim-ts-autotag',
  'mattn/emmet-vim',
  'kylechui/nvim-surround',
  'neovim/nvim-lspconfig',
  'SidOfc/carbon.nvim',
  'vuki656/package-info.nvim',
  'hrsh7th/vim-vsnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/cmp-nvim-lsp',
  'norcalli/nvim-colorizer.lua',
  'sbdchd/neoformat',
  'nvim-treesitter/nvim-treesitter',
}

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Use system clipboard
vim.o.clipboard = 'unnamed'
-- indent by 2 spaces by default
vim.o.shiftwidth = 2
vim.o.expandtab = true
-- Make line numbers default
vim.wo.number = true
-- Add line width marker
vim.o.colorcolumn = '81'
-- Show signs in the number column
vim.wo.signcolumn = 'number'
-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Don't add paragraph jumps to jumplist
vim.keymap.set('n', '}', '<cmd>execute "keepjumps norm! " . v:count1 . "}"<CR>', { silent = true })
vim.keymap.set('n', '{', '<cmd>execute "keepjumps norm! " . v:count1 . "{"<CR>', { silent = true })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Theme
vim.o.termguicolors = true
vim.cmd [[colorscheme nord]]

-- PLUGINS
require('nvim-surround').setup()
require('package-info').setup()
require('autoclose').setup()
require('nvim-ts-autotag').setup()
require('gitsigns').setup()

require('lualine').setup {
  sections = {
    lualine_b = { { 'filename', file_status = true } },
    lualine_c = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { { 'branch', icon = '' } },
  },
}

require('colorizer').setup({ '*' }, {
  names = false,
  css_fn = true,
})

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'lua', 'tsx', 'typescript', 'vue', 'svelte', 'css', 'scss', 'astro', 'html', 'javascript' },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
}

-- Emmet
vim.g.user_emmet_leader_key = ','

-- Telescope
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>*', require('telescope.builtin').grep_string)

-- File Tree
require('carbon').setup {
  actions = { create = 'a', quit = '<esc>' },
  highlights = { CarbonFloat = { bg = require('nord.colors').palette.polar_night.origin } },
}

vim.keymap.set('n', '<leader><', ':Fcarbon!<CR>')

-- LSP
local lspconfig = require 'lspconfig'

lspconfig.tsserver.setup {}
lspconfig.eslint.setup {}
lspconfig.stylelint_lsp.setup { filetypes = { 'scss', 'css' } }
lspconfig.cssls.setup {}
lspconfig.astro.setup {}
lspconfig.svelte.setup {}
lspconfig.rubocop.setup {}

vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { silent = true })
vim.keymap.set('v', 'ga', vim.lsp.buf.code_action, { silent = true })
vim.keymap.set('n', 'ge', vim.diagnostic.goto_next, { silent = true })
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev, { silent = true })

-- CMP
local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },

  sources = {
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Formatter
local format = vim.api.nvim_create_augroup('format', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  command = 'EslintFixAll',
  pattern = '*.ts,*.tsx,*.js,*.jsx,*.vue,*.svelte',
  group = format,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = format,
  command = 'Neoformat',
})

vim.g.neoformat_ruby_rubocop = {}
