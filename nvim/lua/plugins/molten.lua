return {
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false,
    config = function()
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
          enabled = true,
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
  },
}
