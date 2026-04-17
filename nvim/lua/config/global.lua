-- Python provider for molten-nvim
vim.g.python3_host_prog = vim.fn.expand('~/.pixi/envs/python/bin/python')

-- border style used by lsp and completion popups
vim.g.border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }

local animals = {
  '🦝', '🐀', '🦔', '🦡', '🐾', '🦆', '🦢', '🦜', '🦚', '🦩',
  '🦤', '🦥', '🦦', '🦨', '🦛', '🦙', '🦘', '🦡', '🦎', '🦖',
  '🦕', '🦔', '🦓', '🦒', '🐭', '🐿️', '🐻', '🦫', '🦄',
}

vim.opt.termguicolors = true

vim.api.nvim_set_hl(0, 'TermCursor', { fg = '#A6E3A1', bg = '#A6E3A1' })

vim.o.fillchars = 'eob: '

vim.opt.mouse = 'a'
vim.opt.mousefocus = true
vim.opt.clipboard:append 'unnamedplus'

vim.opt.timeoutlen = 400
vim.opt.updatetime = 250

vim.opt.shortmess:append 'A'
vim.opt.showmode = false

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes:1'

vim.opt.completeopt = 'menuone,noinsert'
vim.opt.laststatus = 3

vim.cmd [[
let g:currentmode={
       \ 'n'  : '%#String# NORMAL ',
       \ 'v'  : '%#Search# VISUAL ',
       \ 's'  : '%#ModeMsg# VISUAL ',
       \ "\<C-V>" : '%#Title# V·Block ',
       \ 'V'  : '%#IncSearch# V·Line ',
       \ 'Rv' : '%#String# V·Replace ',
       \ 'i'  : '%#ModeMsg# INSERT ',
       \ 'R'  : '%#Substitute# R ',
       \ 'c'  : '%#CurSearch# Command ',
       \ 't'  : '%#ModeMsg# TERM ',
       \}
]]

math.randomseed(os.time())
local i = math.random(#animals)
vim.opt.statusline = '%{%g:currentmode[mode()]%} %{%reg_recording()%} %* %t | %y | %* %= c:%c l:%l/%L %p%% %#NonText# ' .. animals[i] .. ' %*'

vim.opt.cmdheight = 1
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.formatoptions:remove 'c'
vim.opt.formatoptions:remove 'r'
vim.opt.formatoptions:remove 'o'

vim.opt.scrolloff = 5
vim.opt.conceallevel = 0

vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  signs = true,
}

vim.filetype.add {
  extension = {
    ojs = 'javascript',
  },
}

vim.cmd.packadd 'cfilter'
