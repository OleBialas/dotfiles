-- required in which-key plugin spec in plugins/ui.lua as `require 'config.keymap'`
local wk = require 'which-key'

P = vim.print

local nmap = function(key, effect)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true })
end

local vmap = function(key, effect)
  vim.keymap.set('v', key, effect, { silent = true, noremap = true })
end

local imap = function(key, effect)
  vim.keymap.set('i', key, effect, { silent = true, noremap = true })
end

local cmap = function(key, effect)
  vim.keymap.set('c', key, effect, { silent = true, noremap = true })
end

-- move in command line
cmap('<C-a>', '<Home>')

-- save with ctrl+s
imap('<C-s>', '<esc>:update<cr><esc>')
nmap('<C-s>', '<cmd>:update<cr><esc>')

-- Move between windows using <ctrl> direction
nmap('<C-j>', '<C-W>j')
nmap('<C-k>', '<C-W>k')
nmap('<C-h>', '<C-W>h')
nmap('<C-l>', '<C-W>l')

-- Resize window using <shift> arrow keys
nmap('<S-Up>', '<cmd>resize +2<CR>')
nmap('<S-Down>', '<cmd>resize -2<CR>')
nmap('<S-Left>', '<cmd>vertical resize -2<CR>')
nmap('<S-Right>', '<cmd>vertical resize +2<CR>')

-- Add undo break-points
imap(',', ',<c-g>u')
imap('.', '.<c-g>u')
imap(';', ';<c-g>u')

nmap('Q', '<Nop>')

-- keep selection after indent/dedent
vmap('>', '>gv')
vmap('<', '<gv')

-- center after search and jumps
nmap('n', 'nzz')
nmap('<c-d>', '<c-d>zz')
nmap('<c-u>', '<c-u>zz')

-- tab navigation
nmap('H', '<cmd>tabprevious<cr>')
nmap('L', '<cmd>tabnext<cr>')

local function toggle_light_dark_theme()
  if vim.o.background == 'light' then
    vim.o.background = 'dark'
  else
    vim.o.background = 'light'
  end
end

-- normal mode
wk.add({
  { '<c-LeftMouse>', '<cmd>lua vim.lsp.buf.definition()<CR>', desc = 'go to definition' },
  { '<c-q>', '<cmd>q<cr>', desc = 'close buffer' },
  { '<esc>', '<cmd>noh<cr>', desc = 'remove search highlight' },
  { '[q', ':silent cprev<cr>', desc = '[q]uickfix prev' },
  { ']q', ':silent cnext<cr>', desc = '[q]uickfix next' },
  { 'gN', 'Nzzzv', desc = 'center search' },
  { 'gf', ':e <cfile><CR>', desc = 'edit file' },
  { 'gl', '<c-]>', desc = 'open help link' },
  { 'n', 'nzzzv', desc = 'center search' },
  { 'z?', ':setlocal spell!<cr>', desc = 'toggle [z]pellcheck' },
  { 'zl', ':Telescope spell_suggest<cr>', desc = '[l]ist spelling suggestions' },
}, { mode = 'n', silent = true })

-- visual mode
wk.add({
  {
    mode = { 'v' },
    { '.', ':norm .<cr>', desc = 'repeat last normal mode command' },
    { '<M-j>', ":m'>+<cr>`<my`>mzgv`yo`z", desc = 'move line down' },
    { '<M-k>', ":m'<-2<cr>`>my`<mzgv`yo`z", desc = 'move line up' },
    { '<cr>', ':<C-u>MoltenEvaluateVisual<cr>gv', desc = 'molten eval visual' },
    { 'q', ':norm @q<cr>', desc = 'repeat q macro' },
  },
})

-- visual with <leader>
wk.add({
  { '<leader>d', '"_d', desc = 'delete without overwriting reg', mode = 'v' },
  { '<leader>p', '"_dP', desc = 'replace without overwriting reg', mode = 'v' },
}, { mode = 'v' })

-- insert mode
wk.add({
  {
    mode = { 'i' },
    { '<c-x><c-x>', '<c-x><c-o>', desc = 'omnifunc completion' },
  },
}, { mode = 'i' })

-- normal mode with <leader>
wk.add({
  {
    { '<leader><cr>', ':MoltenEvaluateOperator<cr>', desc = 'molten eval operator' },

    { '<leader>e', group = '[e]dit' },

    { '<leader>f', group = '[f]ind (telescope)' },
    { '<leader>f<space>', '<cmd>Telescope buffers<cr>', desc = '[ ] buffers' },
    { '<leader>fM', '<cmd>Telescope man_pages<cr>', desc = '[M]an pages' },
    { '<leader>fb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = '[b]uffer fuzzy find' },
    { '<leader>fc', '<cmd>Telescope git_commits<cr>', desc = 'git [c]ommits' },
    { '<leader>fd', '<cmd>Telescope buffers<cr>', desc = '[d] buffers' },
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = '[f]iles' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = '[g]rep' },
    { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = '[h]elp' },
    { '<leader>fj', '<cmd>Telescope jumplist<cr>', desc = '[j]umplist' },
    { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = '[k]eymaps' },
    { '<leader>fl', '<cmd>Telescope loclist<cr>', desc = '[l]oclist' },
    { '<leader>fm', '<cmd>Telescope marks<cr>', desc = '[m]arks' },
    { '<leader>fq', '<cmd>Telescope quickfix<cr>', desc = '[q]uickfix' },

    { '<leader>g', group = '[g]it (gitsigns)' },
    -- gitsigns also adds <leader>gs/gr/gp/gb/gd/gtb on attach

    { '<leader>h', group = '[h]ide / [h]elp' },
    { '<leader>hc', group = '[c]onceal' },
    { '<leader>hch', ':set conceallevel=1<cr>', desc = '[h]ide/conceal' },
    { '<leader>hcs', ':set conceallevel=0<cr>', desc = '[s]how/unconceal' },
    { '<leader>ht', group = '[t]reesitter' },
    { '<leader>htt', vim.treesitter.inspect_tree, desc = 'show [t]ree' },

    { '<leader>l', group = '[l]anguage/lsp' },
    { '<leader>la', vim.lsp.buf.code_action, desc = 'code [a]ction' },
    { '<leader>ld', group = '[d]iagnostics' },
    { '<leader>ldd', function() vim.diagnostic.enable(false) end, desc = '[d]isable' },
    { '<leader>lde', vim.diagnostic.enable, desc = '[e]nable' },
    { '<leader>le', vim.diagnostic.open_float, desc = 'diagnostics (show hover [e]rror)' },

    -- molten / jupyter
    { '<leader>m', group = '[m]olten / jupyter' },
    { '<leader>mi', ':MoltenInit<cr>', desc = '[i]nit kernel' },
    { '<leader>md', ':MoltenDeinit<cr>', desc = '[d]einit kernel' },
    { '<leader>me', ':MoltenEvaluateOperator<cr>', desc = '[e]val operator' },
    { '<leader>ml', ':MoltenEvaluateLine<cr>', desc = 'eval [l]ine' },
    { '<leader>mr', ':MoltenReevaluateCell<cr>', desc = '[r]e-eval cell' },
    { '<leader>mh', ':MoltenHideOutput<cr>', desc = '[h]ide output' },
    { '<leader>ms', ':MoltenShowOutput<cr>', desc = '[s]how output' },
    { '<leader>mo', ':noautocmd MoltenEnterOutput<cr>', desc = 'enter [o]utput' },
    { '<leader>mx', ':MoltenInterrupt<cr>', desc = 'interrupt (e[x])' },
    { '<leader>mR', ':MoltenRestart<cr>', desc = '[R]estart kernel' },
    { '<leader>mD', ':MoltenDelete<cr>', desc = '[D]elete cell' },

    { '<leader>v', group = '[v]im' },
    { '<leader>vc', ':Telescope colorscheme<cr>', desc = '[c]olortheme' },
    { '<leader>vh', ':execute "h " . expand("<cword>")<cr>', desc = 'vim [h]elp for current word' },
    { '<leader>vl', ':Lazy<cr>', desc = '[l]azy package manager' },
    { '<leader>vm', ':Mason<cr>', desc = '[m]ason software installer' },
    { '<leader>vs', ':e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>', desc = '[s]ettings, edit vimrc' },
    { '<leader>vt', toggle_light_dark_theme, desc = '[t]oggle light/dark theme' },

    { '<leader>x', group = 'e[x]ecute' },
    { '<leader>xx', ':w<cr>:source %<cr>', desc = '[x] source %' },
  }
}, { mode = 'n' })
