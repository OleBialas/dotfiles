return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'
      local previewers = require 'telescope.previewers'
      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        filepath = vim.fn.expand(filepath)
        vim.loop.fs_stat(filepath, function(_, stat)
          if not stat then
            return
          end
          if stat.size > 100000 then
            return
          else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end)
      end

      local telescope_config = require 'telescope.config'
      local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!docs/*')

      telescope.setup {
        defaults = {
          buffer_previewer_maker = new_maker,
          vimgrep_arguments = vimgrep_arguments,
          file_ignore_patterns = {
            'node_modules',
            '%_cache',
            '.git/',
            'site_libs',
            '.venv',
          },
          layout_strategy = 'flex',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
          },
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<c-d>'] = actions.delete_buffer,
              ['<esc>'] = actions.close,
              ['<c-j>'] = actions.move_selection_next,
              ['<c-k>'] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = false,
            find_command = {
              'rg',
              '--files',
              '--hidden',
              '--glob',
              '!.git/*',
              '--glob',
              '!_site/*',
              '--glob',
              '!docs/**/*.html',
              '-L',
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      }
      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<c-t>', ':NvimTreeToggle<cr>', desc = 'toggle nvim-tree' },
    },
    config = function()
      require('nvim-tree').setup {
        disable_netrw = true,
        update_focused_file = {
          enable = true,
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
        diagnostics = {
          enable = true,
        },
      }
    end,
  },

  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
      require 'config.keymap'
    end,
  },
}
