local g   = vim.g
local o   = vim.o
local opt = vim.opt
local A   = vim.api

o.termguicolors = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true

-- Better editing experience
o.expandtab = true
o.smarttab = true
o.cindent = true
o.autoindent = true
o.wrap = true
o.textwidth = 300
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.list = true
o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

-- Makes neovim and host OS clipboard play nicely with each other
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

opt.mouse = "a"

-- Map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '

-------------------------------------------------
-- COLORSCHEMES
-------------------------------------------------

-- Activate linelight when in goyo-mode
vim.cmd [[
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
]]
-- Uncomment just ONE of the following colorschemes!
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-dracula')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-gruvbox-dark-medium')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-monokai')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-nord')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-oceanicnext')
local ok, _ = pcall(vim.cmd, 'colorscheme base16-onedark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-solarized-dark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-solarized-light')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-tomorrow-night')

-------------------------------------------------
-- KEYBINDINGS
-------------------------------------------------
local function map(m, k, v)
   vim.keymap.set(m, k, v, { silent = true })
end

-- Open and close nerdtree
map('n', '<F6>', '<CMD>NERDTreeToggle<CR>')

-- Format Python code with black
map('n', '<leader>ck', '<CMD>Black<CR>')

-- Keybindings for telescope
map('n', '<leader>fr', '<CMD>Telescope oldfiles<CR>')
map('n', '<leader>ff', '<CMD>Telescope find_files<CR>')
map('n', '<leader>fb', '<CMD>Telescope file_browser<CR>')
map('n', '<leader>fw', '<CMD>Telescope live_grep<CR>')
map('n', '<leader>ht', '<CMD>Telescope colorscheme<CR>')
-------------------------------------------------
-- DASHBOARD
-------------------------------------------------

local db = require('dashboard')
local home = os.getenv('HOME')

db.default_banner = {
  '',
  '',
  ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
  ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
  ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
  ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
  ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
  ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
  '',
  '',
}
-- linux
--db.preview_command = 'ueberzug'
--
--db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
db.preview_file_height = 11
db.preview_file_width = 70
db.custom_center = {
    {desc = 'Recent sessions                         ',
    shortcut = 'SPC s l',
    action ='SessionLoad'},
    {desc = 'Find recent files                       ',
    action = 'Telescope oldfiles',
    shortcut = 'SPC f r'},
    {desc = 'Find files                              ',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    shortcut = 'SPC f f'},
    {desc ='File browser                            ',
    action =  'Telescope file_browser',
    shortcut = 'SPC f b'},
    {desc = 'Find word                               ',
    action = 'Telescope live_grep',
    shortcut = 'SPC f w'},
    {desc = 'Open wiki                               ',
    shortcut = 'SPC w w'},
    {desc = 'Load new theme                          ',
    action = 'Telescope colorscheme',
    shortcut = 'SPC h t'},
  }
db.session_directory = "/home/dt/.config/nvim/session"

-------------------------------------------------
-- PLUGINS
-------------------------------------------------

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Dashboard is a nice start screen for nvim
  use 'glepnir/dashboard-nvim'

  -- Telescope and related plugins --
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { "nvim-telescope/telescope-file-browser.nvim",
        config = function()
        require("telescope").setup {
          extensions = {
            file_browser = {
              theme = "ivy",
              -- disables netrw and use telescope-file-browser in its place
              hijack_netrw = true,
              mappings = {
                ["i"] = {
                  -- your custom insert mode mappings
                },
                ["n"] = {
                  -- your custom normal mode mappings
                },
              },
            },
          },
        }
        end
  }

  -- Treesitter for syntax highlighting
  use {'nvim-treesitter/nvim-treesitter',
       config = function()
          require'nvim-treesitter.configs'.setup {
          -- If TS highlights are not enabled at all, or disabled via `disable` prop,
          -- highlighting will fallback to default Vim syntax highlighting
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = {'org'}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
               },
            ensure_installed = {'org'}, -- Or run :TSUpdate org
            }
       end
  }

  -- Which key
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      }
    end
  }

  -- To get telescope-file-browser loaded and working with telescope,
  -- you need to call load_extension, somewhere after setup function:
  require("telescope").load_extension "file_browser"

  -- A better status line --
  use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  require('lualine').setup()

  -- Colorschemes --
  use 'RRethy/nvim-base16'
  
  -- Beautify
  use 'junegunn/vim-emoji'
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
  
  -- My personal Wiki
  use 'vimwiki/vimwiki'
  vim.g.vimwiki_list = {{path = '~/vimwiki', syntax = 'markdown', ext = '.md'}}

  -- File management
  use 'ctrlpvim/ctrlp.vim'
  use 'jeetsukumaran/vim-buffergator'
  use 'scrooloose/nerdtree'

  -- Language support
  use 'daeyun/vim-matlab'
  use 'preservim/vim-markdown'
  use 'lervag/vimtex'
  use 'jalvesaq/Nvim-R'
  use 'vim-python/python-syntax'
  use 'ambv/black'  -- auto-formatting
end)


