return {
  {
    'nvim-treesitter/nvim-treesitter',
    dev = false,
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      local parsers = {
        'python',
        'markdown',
        'markdown_inline',
        'bash',
        'yaml',
        'lua',
        'vim',
        'query',
        'vimdoc',
        'html',
        'css',
        'javascript',
      }

      require('nvim-treesitter').setup()
      require('nvim-treesitter').install(parsers)

      ---@diagnostic disable-next-line: missing-fields
      vim.api.nvim_create_autocmd('FileType', {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
}
