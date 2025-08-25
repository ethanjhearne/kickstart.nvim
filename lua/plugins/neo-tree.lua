local function show_this_file()
  if vim.bo.buftype == '' then
    -- Regular text buffer (e.g. not 'terminal' or 'nofile'
    vim.api.nvim_exec2(':Neotree focus filesystem %', {})
  else
    vim.api.nvim_exec2(':Neotree focus filesystem', {})
  end
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    vim.keymap.set('n', '<leader>ef', show_this_file, { desc = '[e]xplore (and show this [f]ile)' })
    vim.keymap.set('n', '<leader>eF', ':Neotree focus filesystem<CR>', { desc = '[e]xplore [f]iles' })
    vim.keymap.set('n', '<leader>eb', ':Neotree focus buffers<CR>', { desc = '[e]xplore [b]uffers' })
    vim.keymap.set('n', '<leader>eq', ':Neotree close<CR>', { desc = '[e]xplorer [q]uit' })
  end,
}
