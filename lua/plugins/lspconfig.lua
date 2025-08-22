return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local imap = function(keys, func, desc)
          vim.keymap.set('i', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Clashed with my "write" keymap
        -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Taken from: https://github.com/neovim/nvim-lspconfig/blob/fd26f8626c03b424f7140d454031d1dcb8d23513/lua/lspconfig/configs/pyright.lua#L3-L11
    local python_root_files = {
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
      'pyrightconfig.json',
      '.git',
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local format_settings = {
      format = {
        convertTabsToSpaces = true,
        indentSize = 4,
      },
    }
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      clangd = {
        -- This is for when you're running nvim in WSL, but want to use the Windows installation of clangd
        -- cmd = { 'clangd.exe' }
        -- cmd = { 'clangd', '-w' },
        cmd = { 'clangd', '--function-arg-placeholders=0' },
      },
      -----------------------------
      -- Couldn't figure out how to get this to only use types for suggestions,
      -- not for yelling at me in a million places!
      -----------------------------
      -- basedpyright = {
      --   settings = {
      --     basedpyright = {
      --       analysis = {
      --         typeCheckingMode = 'basic',
      --       },
      --     },
      --   },
      --   root_dir = function(fname)
      --     local result = vim.fs.root(fname, python_root_files)
      --     print('found root dir = ' .. result)
      --     return result
      --   end,
      -- },
      -----------------------------
      -- pylsp = {
      --   settings = {
      --     pylsp = {
      --       plugins = {
      --         autopep8 = { enabled = true },
      --         flake8 = { enabled = false },
      --         mccabe = { enabled = true },
      --         pycodestyle = { enabled = false },
      --         pyflakes = { enabled = false },
      --         pylint = { enabled = false },
      --         rope_autoimport = { enabled = true },
      --         rope_completion = { enabled = false },
      --         yapf = { enabled = false },
      --       },
      --     },
      --   },
      -- },
      pyright = {
        root_dir = function(fname)
          return vim.fs.root(fname, python_root_files)
        end,
      },
      tsserver = {
        settings = {
          javascript = format_settings,
          typescript = format_settings,
        },
      },
      markdown_oxide = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      },
    }

    local setup_server = function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end

    local disabled = function(server_name) end

    -- These servers are assumed to be installed externally already
    setup_server 'clangd'

    -- The rest are installed by mason
    require('mason').setup()
    require('mason-lspconfig').setup()
    require('mason-lspconfig').setup_handlers {
      setup_server,
      ['jedi_language_server'] = disabled,
      ['basedpyright'] = disabled,
      ['pylsp'] = disabled,
    }
  end,
}
