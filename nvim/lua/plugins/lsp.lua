return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    ft = { 'python' },
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
          'yaml-language-server', 'pyright',
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

      local default_publish_diagnostics = vim.lsp.handlers['textDocument/publishDiagnostics']

      local function apply_active_python_env(config)
        local ok, venv_selector = pcall(require, 'venv-selector')
        local python = ok and venv_selector.python() or nil
        if not python or python == '' then
          return
        end

        local venv_dir = vim.fn.fnamemodify(python, ':h:h')
        local venv_name = vim.fn.fnamemodify(venv_dir, ':t')
        local venv_path = vim.fn.fnamemodify(venv_dir, ':h')

        config.settings = config.settings or {}
        config.settings.python = vim.tbl_deep_extend('force', config.settings.python or {}, {
          pythonPath = python,
          venv = venv_name,
          venvPath = venv_path,
        })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      if capabilities.workspace == nil then
        capabilities.workspace = {}
        capabilities.workspace.didChangeWatchedFiles = {}
      end
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      local lsp_flags = { allow_incremental_sync = true, debounce_text_changes = 150 }

      local function diagnostic_line_number(diagnostic)
        return diagnostic.lnum or diagnostic.range and diagnostic.range.start and diagnostic.range.start.line
      end

      local function is_jupyter_shell_escape(bufnr, diagnostic)
        local line_number = diagnostic_line_number(diagnostic)
        if line_number == nil then return false end

        local ok, line = pcall(vim.api.nvim_buf_get_lines, bufnr, line_number, line_number + 1, false)
        return ok and line[1] and line[1]:match('^%s*!') ~= nil
      end

      local function is_notebook_buffer(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match('%.ipynb') then
          return true
        end

        local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, -1, false)
        if not ok then
          return false
        end

        for _, line in ipairs(lines) do
          if line:match('^# %%%%') then
            return true
          end
        end

        return false
      end

      local function is_notebook_cell_result_expression(bufnr, diagnostic)
        if diagnostic.code ~= 'reportUnusedExpression' then
          return false
        end

        local line_number = diagnostic_line_number(diagnostic)
        if line_number == nil then return false end

        local ok, current_line = pcall(vim.api.nvim_buf_get_lines, bufnr, line_number, line_number + 1, false)
        if not ok or not current_line[1] or not current_line[1]:match('^%s*[%a_][%w_%.]*%s*$') then
          return false
        end

        local lines = vim.api.nvim_buf_get_lines(bufnr, line_number + 1, -1, false)
        for _, line in ipairs(lines) do
          if line:match('^# %%%%') then
            return true
          end
          if line:match('%S') then
            return false
          end
        end

        return true
      end

      if not vim.g.notebook_diagnostic_filter_set then
        vim.g.notebook_diagnostic_filter_set = true
        local diagnostic_set = vim.diagnostic.set

        vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
          if diagnostics and is_notebook_buffer(bufnr) then
            diagnostics = vim.tbl_filter(function(diagnostic)
              return not is_notebook_cell_result_expression(bufnr, diagnostic)
                and not is_jupyter_shell_escape(bufnr, diagnostic)
            end, diagnostics)
          end

          return diagnostic_set(namespace, bufnr, diagnostics, opts)
        end
      end

      vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        if result and result.diagnostics then
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          local bufnr = vim.uri_to_bufnr(result.uri)
          if client and client.name == 'pyright' and is_notebook_buffer(bufnr) then
            result = vim.deepcopy(result)
            result.diagnostics = vim.tbl_filter(function(diagnostic)
              return not is_notebook_cell_result_expression(bufnr, diagnostic)
                and not is_jupyter_shell_escape(bufnr, diagnostic)
            end, result.diagnostics)
          end
        end

        return default_publish_diagnostics(err, result, ctx, config)
      end

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
          before_init = function(_, config)
            apply_active_python_env(config)
          end,
          on_new_config = function(config)
            apply_active_python_env(config)
          end,
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

      -- Re-fire FileType for the current buffer in case lspconfig loaded
      -- after the event already fired (e.g. jupytext .ipynb files)
      vim.schedule(function()
        local ft = vim.bo.filetype
        if ft ~= '' then
          vim.api.nvim_exec_autocmds('FileType', { pattern = ft })
        end
      end)
    end,
  },

  {
    'linux-cultist/venv-selector.nvim',
    ft = 'python',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim' },
    opts = {
      options = {
        fd_binary_name = 'fdfind',
        on_venv_activate_callback = function()
          require('venv-selector').restart_lsp_servers()
        end,
      },
      search = {
        pixi = {
          command = 'fdfind python$ .pixi/envs --full-path -L',
        },
      },
    },
    keys = {
      { '<leader>lv', '<cmd>VenvSelect<cr>', desc = 'select [v]env' },
    },
  },
}
