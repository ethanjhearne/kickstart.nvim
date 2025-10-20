return {
  'christoomey/vim-tmux-navigator',
  lazy=false,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  config = function()
    vim.g.tmux_navigator_no_wrap = true

    vim.keymap.set('t', '<C-h>', '<C-\\><C-N><CMD>TmuxNavigateLeft<CR>', { desc = 'Move focus to the left window' })
    vim.keymap.set('t', '<C-l>', '<C-\\><C-N><CMD>TmuxNavigateRight<CR>', { desc = 'Move focus to the right window' })
    vim.keymap.set('t', '<C-j>', '<C-\\><C-N><CMD>TmuxNavigateDown<CR>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('t', '<C-k>', '<C-\\><C-N><CMD>TmuxNavigateUp<CR>', { desc = 'Move focus to the upper window' })

    vim.keymap.set('n', '<C-h>', '<CMD>TmuxNavigateLeft<CR>', { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-l>', '<CMD>TmuxNavigateRight<CR>', { desc = 'Move focus to the right window' })
    vim.keymap.set('n', '<C-j>', '<CMD>TmuxNavigateDown<CR>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', '<CMD>TmuxNavigateUp<CR>', { desc = 'Move focus to the upper window' })
  end,
}
