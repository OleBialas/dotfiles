-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({

    {   -- color scheme
        "navarasu/onedark.nvim",
        config = function()
            vim.cmd.colorscheme("onedark")
        end,
    },


    {   -- file search
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
            vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
            vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
        end,
    },

    {   -- install language parsers
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup ({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "r"},
                auto_install = true,  -- automatically install required parser when opening a file
                highlight = {
                    enable = true,
                },
            })
        end,
    },

    {   -- my personal wiki
        "vimwiki/vimwiki",
        init = function()
            vim.g.vimwiki_list = {{path = '~/zettelkasten', syntax = 'markdown', ext = '.md'}}
        end,
        config = function()
            vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
            vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
            vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
        end,
    },

    {   -- file manager
        "scrooloose/nerdtree"
    },

    {   -- math rendering in terminal
        "jbyuki/nabla.nvim"
    },
    
    {   -- python auto-formatting
        "psf/black"
    },

    {   -- LSP server configuration
        "neovim/nvim-lspconfig" 
    },

    {   -- package manager for LSP servers
        "williamboman/mason.nvim",
        config=function()
            require("mason").setup()
        end,
    },

    {   -- makes mason work nicely with lspconfig
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"mason.nvim"},
        config=function()
            require("mason-lspconfig").setup()

            require("mason-lspconfig").setup_handlers ({
                function (server_name)
                    require("lspconfig")[server_name].setup({})
                end,
            })
        end,
    },

})

