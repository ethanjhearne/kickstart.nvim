return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable LSP fallback for languages that don't have a well standardized
      -- coding style. You can add additional languages here or re-enable it
      -- for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }

      local lsp_format = 'fallback'
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format = 'never'
      end

      return { timeout_ms = 3000, lsp_format = lsp_format }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      markdown = { 'deno_fmt' },
      -- Conform can also run multiple formatters sequentially
      python = { 'isort', 'black' },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      yaml = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      go = { 'goimports' },
    },
  },
}
