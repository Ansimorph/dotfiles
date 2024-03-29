-- Enable fast loader
vim.loader.enable()

require 'paq' {
  'savq/paq-nvim',
  'nvim-lua/plenary.nvim', -- required by telescope
  'MunifTanjim/nui.nvim', -- required by package info
  'gbprod/nord.nvim',
  'lewis6991/gitsigns.nvim',
  'chrisbra/vim-commentary',
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

-- Emmet
vim.g.user_emmet_leader_key = ','

-- Surround
require('nvim-surround').setup()

-- Telescope
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>*', require('telescope.builtin').grep_string)

-- File Tree
require('carbon').setup {
  actions = { create = 'a', quit = '<esc>' },
  highlights = { CarbonFloat = { bg = '#2e3440' } },
  float_settings = function()
    local columns = vim.opt.columns:get()
    local rows = vim.opt.lines:get()
    local width = math.min(80, math.floor(columns * 0.9))
    local height = math.min(20, math.floor(rows * 0.9))

    return {
      relative = 'editor',
      style = 'minimal',
      border = 'rounded',
      width = width,
      height = height,
      col = math.floor(columns / 2 - width / 2),
      row = math.floor(rows / 2 - height / 2 - 2),
    }
  end,
}

vim.keymap.set('n', '<leader><', ':Fcarbon!<CR>')

-- LSP
local lspconfig = require 'lspconfig'

lspconfig.tsserver.setup {}
lspconfig.eslint.setup {}
lspconfig.stylelint_lsp.setup {}
lspconfig.cssls.setup {}
lspconfig.astro.setup {}
lspconfig.svelte.setup {}
lspconfig.vuels.setup {
  settings = {
    vetur = {
      completion = { autoImport = true, tagCasing = 'initial', useScaffoldSnippets = true },
    },
  },
}
lspconfig.angularls.setup {}

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

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Package info
require('package-info').setup()

-- Autoclose
require('autoclose').setup()
require('nvim-ts-autotag').setup()

-- Git Signs
require('gitsigns').setup()

-- Lualine
require('lualine').setup {
  sections = {
    lualine_b = { { 'filename', file_status = true } },
    lualine_c = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { { 'branch', icon = '' } },
  },
}

-- Colorizer
require('colorizer').setup({ '*' }, {
  names = false,
  css_fn = true,
})

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'lua', 'tsx', 'typescript', 'vue', 'svelte', 'css', 'scss', 'astro', 'html', 'javascript' },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
}

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
