return {
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false,
    config = function()
      local utils = require 'jupytext.utils'
      local language_extensions = {
        python = 'py',
        julia = 'jl',
        r = 'r',
        R = 'r',
        bash = 'sh',
      }
      local language_names = {
        python3 = 'python',
      }
      local default_kernel_names = {
        python = 'python3',
      }
      local default_kernel_display_names = {
        python = 'Python 3',
      }

      utils.get_ipynb_metadata = function(filename)
        local file = assert(io.open(filename, 'r'))
        local notebook = vim.json.decode(file:read 'a') or {}
        file:close()

        local metadata = notebook.metadata or {}
        local kernelspec = metadata.kernelspec or {}
        local language_info = metadata.language_info or {}
        local language = kernelspec.language or language_names[kernelspec.name] or language_info.name or 'python'
        language = language_names[language] or language

        if metadata.kernelspec == nil then
          notebook.metadata = metadata
          metadata.kernelspec = {
            display_name = default_kernel_display_names[language] or language,
            language = language,
            name = default_kernel_names[language] or language,
          }

          local output = assert(io.open(filename, 'w'))
          output:write(vim.json.encode(notebook), '\n')
          output:close()
        end

        return { language = language, extension = language_extensions[language] or 'py' }
      end

      require('jupytext').setup {
        custom_language_formatting = {
          python = {
            extension = 'py',
            style = 'hydrogen',
            force_ft = 'python',
          },
        },
      }
    end,
  },

  {
    '3rd/image.nvim',
    lazy = false,
    opts = {
      backend = 'kitty',
      processor = 'magick_cli',

      integrations = {
        markdown = {
          enabled = false,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown', 'vimwiki' },
        },
      },
      max_width = 200,
      max_height = 80,
      max_height_window_percentage = 100,
      max_width_window_percentage = 100,
      scale_factor = 2,
      window_overlap_clear_enabled = true,
    },
  },

  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    ft = { 'python', 'markdown' },
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_image_location = 'float'
      vim.g.molten_output_win_max_height = 60
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = false
    end,
    config = function()
      -- Match Jupyter/VSCode: run notebooks from the notebook file's directory.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MoltenKernelReady',
        callback = function(event)
          local file = vim.api.nvim_buf_get_name(0)
          local dir = vim.fn.fnamemodify(file, ':p:h')
          local kernel_id = event.data and event.data.kernel_id
          if dir ~= '' and kernel_id then
            vim.api.nvim_cmd({
              cmd = 'MoltenEvaluateArgument',
              args = { kernel_id, '%cd ' .. vim.fn.shellescape(dir) },
            }, {})
          end
        end,
      })
    end,
  },
}
