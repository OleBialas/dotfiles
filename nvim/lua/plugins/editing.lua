return {
  { 'LunarVim/bigfile.nvim', event = 'BufReadPre' },

  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'numToStr/Comment.nvim',
    version = nil,
    cond = function()
      return vim.fn.has 'nvim-0.10' == 0
    end,
    branch = 'master',
    config = true,
  },

  {
    'stevearc/conform.nvim',
    keys = {
      { '<leader>cf', '<cmd>lua require("conform").format()<cr>', desc = '[f]ormat' },
    },
    config = function()
      require('conform').setup {
        notify_on_error = false,
        formatters_by_ft = {
          lua = { 'mystylua' },
          python = { 'isort', 'black' },
        },
        formatters = {
          mystylua = {
            command = 'stylua',
            args = { '--indent-type', 'Spaces', '--indent-width', '2', '-' },
          },
        },
      }
    end,
  },
}
