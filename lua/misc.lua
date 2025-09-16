-- OPTIONS --

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.winborder = 'rounded'

vim.diagnostic.config { virtual_lines = { current_line = true } }

-- KEYMAPS --

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

-- AUTOCOMMANDS --

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('custom-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start LSP for C++ files',
  pattern = 'cpp',
  callback = function()
    local root_dir = vim.fs.root(vim.env.PWD, { 'compile_commands.txt', 'main.cpp' })

    if root_dir then
      vim.lsp.start {
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
        root_dir = root_dir,
      }
    end
  end,
})
