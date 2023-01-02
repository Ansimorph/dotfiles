require 'paq' {
  'lewis6991/impatient.nvim',
  'nvim-lua/plenary.nvim', -- required by telescope
  'gbprod/nord.nvim',
  'lewis6991/gitsigns.nvim',
  'chrisbra/vim-commentary',
  'editorconfig/editorconfig-vim',
  'nvim-lualine/lualine.nvim',
  'nvim-telescope/telescope.nvim',
  'windwp/nvim-autopairs',
  'mattn/emmet-vim',
  'tpope/vim-surround',
  'neovim/nvim-lspconfig',
  'SidOfc/carbon.nvim',
  'MunifTanjim/nui.nvim', -- required by package info
  'vuki656/package-info.nvim',
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/cmp-nvim-lsp',
  'norcalli/nvim-colorizer.lua',
  'sbdchd/neoformat',
}

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Indent based on previous line
vim.o.autoindent = true
-- Use system clipboard
vim.o.clipboard = 'unnamed'
-- indent by 2 spaces by default
vim.o.shiftwidth = 2
vim.o.expandtab = true
-- Save when switching buffers
vim.o.autowriteall = true
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
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Use ESC to exit insert mode in :term
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Theme
vim.o.termguicolors = true
vim.cmd [[colorscheme nord]]

-- PLUGINS

-- Impatient
require 'impatient'

-- Emmet
vim.g.user_emmet_leader_key = ','

-- Telescope
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>*', require('telescope.builtin').grep_string)

-- File Tree
require('carbon').setup {
  actions = {
    quit = '<esc>',
    create = { 'a', '%' },
  },
}
vim.keymap.set('n', '<leader><', ':Fcarbon!<CR>')

-- LSP
local lspconfig = require 'lspconfig'

lspconfig.tsserver.setup {}
lspconfig.eslint.setup {}
lspconfig.stylelint_lsp.setup {}
lspconfig.cssls.setup {}
lspconfig.astro.setup {}

vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { silent = true })
vim.keymap.set('v', 'ga', vim.lsp.buf.code_action, { silent = true })
vim.keymap.set('n', 'ge', vim.diagnostic.goto_next, { silent = true })
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev, { silent = true })

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
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },

  sources = {
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'path' },
  },
}

cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Package info
require('package-info').setup()

-- Autopair
require('nvim-autopairs').setup()

-- Git Signs
require('gitsigns').setup()

-- Lualine
require('lualine').setup {
  options = { theme = 'nord' },
  sections = {
    lualine_a = { { 'mode' } },
    lualine_b = { { 'filename', file_status = true } },
    lualine_c = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { { 'branch', icon = '' } },
    lualine_z = { 'location' },
  },
  extensions = { 'quickfix' },
}

-- Colorizer
require('colorizer').setup({ '*' }, {
  names = false,
  css_fn = true,
})

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

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = vim.lsp.buf.formatting,
  pattern = '*.astro',
  group = format,
})
