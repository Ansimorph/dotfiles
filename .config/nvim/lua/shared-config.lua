-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Indent based on previous line
vim.o.autoindent = true

-- Use system clipboard
vim.o.clipboard = "unnamed"

-- indent by 2 spaces by default
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Emmet
vim.g.user_emmet_leader_key = ","

-- Y yank until the end of line  (note: this is now a default on master)
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true })

-- s for substitute
vim.api.nvim_set_keymap("n", "s", "<plug>(SubversiveSubstitute)", {})
vim.api.nvim_set_keymap("n", "ss", "<plug>(SubversiveSubstituteLine)", {})
vim.api.nvim_set_keymap("n", "S", "<plug>(SubversiveSubstituteToEndOfLine)", {})
vim.api.nvim_set_keymap("x", "s", "p", {})
