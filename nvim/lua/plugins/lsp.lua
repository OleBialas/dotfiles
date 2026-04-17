return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        },
      },
      { 'Bilal2453/luvit-meta', lazy = true },
      {
        'hrsh7th/nvim-cmp',
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, { name = 'lazydev', group_index = 0 })
        end,
      },
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup { automatic_installation = true }
      require('mason-tool-installer').setup {
        ensure_installed = {
          'black', 'stylua', 'shfmt', 'isort', 'tree-sitter-cli', 'jupytext',
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local function map(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local function vmap(keys, func, desc)
            vim.keymap.set('v', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          assert(client, 'LSP client not found')
          ---@diagnostic disable-next-line: inject-field
          client.server_capabilities.document_formatting = true

          map('gS', vim.lsp.buf.document_symbol, '[g]o to [S]ymbols')
          map('gD', vim.lsp.buf.type_definition, '[g]o to type [D]efinition')
          map('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
          map('K', vim.lsp.buf.hover, '[K] hover documentation')
          map('gh', vim.lsp.buf.signature_help, '[g]o to signature [h]elp')
          map('gI', vim.lsp.buf.implementation, '[g]o to [I]mplementation')
          map('gr', vim.lsp.buf.references, '[g]o to [r]eferences')
          map('[d', function() vim.diagnostic.jump({ count = 1 }) end, 'previous [d]iagnostic')
          map(']d', function() vim.diagnostic.jump({ count = -1 }) end, 'next [d]iagnostic')
          map('<leader>ll', vim.lsp.codelens.run, '[l]ens run')
          map('<leader>lR', vim.lsp.buf.rename, '[l]sp [R]ename')
          map('<leader>lf', vim.lsp.buf.format, '[l]sp [f]ormat')
          vmap('<leader>lf', vim.lsp.buf.format, '[l]sp [f]ormat')
          map('<leader>lq', vim.diagnostic.setqflist, '[l]sp diagnostic [q]uickfix')
        end,
      })

      vim.o.winborder = 'rounded'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      if capabilities.workspace == nil then
        capabilities.workspace = {}
        capabilities.workspace.didChangeWatchedFiles = {}
      end
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      local lsp_flags = { allow_incremental_sync = true, debounce_text_changes = 150 }

      local servers = {
        marksman = {
          filetypes = { 'markdown' },
        },
        cssls = {},
        html = {},
        yamlls = {
          settings = {
            yaml = { schemaStore = { enable = true, url = '' } },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              runtime = { version = 'LuaJIT' },
              diagnostics = { disable = { 'trailing-space' } },
              workspace = { checkThirdParty = false },
              doc = { privateName = { '^_' } },
              telemetry = { enable = false },
            },
          },
        },
        bashls = {
          filetypes = { 'sh', 'bash' },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.flags = lsp_flags
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
}
