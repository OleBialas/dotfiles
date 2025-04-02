return {
  {
    'shaunsingh/nord.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
  },
  {
    'folke/tokyonight.nvim',
    enabled = true,
    lazy = false,
    priority = 1000
  },
  {
    'EdenEast/nightfox.nvim',
    enabled = true,
    lazy = false,
    priority = 1000
  },
  {
    'navarasu/onedark.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      -- Set onedark as default
      vim.cmd.colorscheme("onedark")
    end
  },
  {
    'neanias/everforest-nvim',
    enabled = true,
    lazy = false,
    priority = 1000
  }
}
