vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit' })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = '[W]rite' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-N><C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-N><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>\\', ':vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>-', ':split<CR>', { desc = 'Horizontal split' })

vim.keymap.set('n', '<leader>mr', ':make run<CR>', { desc = '[M]ake [r]un' })
vim.keymap.set('n', '<leader>mt', ':make test<CR>', { desc = '[M]ake [t]est' })
