return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    vim.keymap.set('n', '<leader>ef', ':Neotree focus filesystem %<CR>', { desc = '[e]xplorer ([f]ilesystem)' })
    vim.keymap.set('n', '<leader>eb', ':Neotree focus buffers<CR>', { desc = '[e]xplorer ([b]uffers)' })
    vim.keymap.set('n', '<leader>eq', ':Neotree close<CR>', { desc = '[e]xplorer ([q]uit)' })
    vim.keymap.set('n', '<leader>eh', ':Neotree show position=left<CR>', { desc = '[e]xplorer move left' })
  end,
}
