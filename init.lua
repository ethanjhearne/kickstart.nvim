require 'misc'
require 'terminal'
require 'goto-github'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  require 'plugins.vim-sleuth',
  require 'plugins.neo-tree',
  require 'plugins.gitsigns',
  require 'plugins.whichkey',
  require 'plugins.telescope',
  require 'plugins.lazydev',
  require 'plugins.conform',
  require 'plugins.nvim-cmp',
  require 'plugins.nightfox',
  require 'plugins.todo-comments',
  require 'plugins.mini',
  require 'plugins.treesitter',
  require 'plugins.tmux-navigator',
  require 'plugins.nvim-ts-autotag',

  -- TODO: Try this out. Is it better than makeprg + qflist?
  -- require 'plugins.testing',

  -- TODO: Read through: https://dev.to/vonheikemen/getting-started-with-neovims-native-lsp-client-in-the-year-of-2022-the-easy-way-bp3
  require 'plugins.lspconfig',

  -- TODO: How much of the stuff below can you delete? --

  -- TODO: Can this integrate with ChatGPT? Can it provide a chat box? Can it
  -- do agent mode?
  require 'plugins.copilot',

  -- TODO: Is this nicer than lazyvim?
  -- TODO: See if you like this even better paired with fugitive
  require 'plugins.gitsigns',

  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
