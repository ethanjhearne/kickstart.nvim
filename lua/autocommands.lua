
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  pattern = 'term://*',
  callback = function()
      vim.opt.number = false
      vim.opt.relativenumber = false
      vim.cmd.startinsert()
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.diagnostic.config {
      float = {
        border = 'rounded',
      },
    }
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
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
