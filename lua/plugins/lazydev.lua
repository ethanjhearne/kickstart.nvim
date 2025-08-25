-- LSP config for nvim lua files
return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
