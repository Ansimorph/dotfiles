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

-- Emmet
vim.g.user_emmet_leader_key = ','

-- Y yank until the end of line  (note: this is now a default on master)
vim.keymap.set('n', 'Y', 'y$')

-- s for substitute
vim.keymap.set('n', 's', '<plug>(SubversiveSubstitute)')
vim.keymap.set('n', 'ss', '<plug>(SubversiveSubstituteLine)')
vim.keymap.set('n', 'S', '<plug>(SubversiveSubstituteToEndOfLine)')
vim.keymap.set('x', 's', 'p')
