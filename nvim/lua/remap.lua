vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move highlighted lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- cursor does not move while concatenating line below
vim.keymap.set("n", "J", "mzJ`z")

-- make cursor stay in the middle during half-page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- make cursor stay in the middle during searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste over something without loosing what is currently in clipboard
vim.keymap.set("x", "<leader>p", [["_dP]])

-- preview markdown in a new window
vim.keymap.set("n", "<leader>mm", "<CMD>MarkdownPreviewToggle<CR>")

-- delete without copying to clipboard
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- copy into system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- don't use capital Q
vim.keymap.set("n", "Q", "<nop>")

-- replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Toggle math rendering
vim.keymap.set("n", "<leader>m", function() require("nabla").popup() end)

-- Open and close nerdtree
vim.keymap.set('n', '<F6>', '<CMD>NERDTreeToggle<CR>')

-- use Esc to exit to normal mode in terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- use alt and h,j,k,l to move between splits
vim.keymap.set('t', '<A-h>', [[<C-\><C-N><C-w>h]])
vim.keymap.set('t', '<A-j>', [[<C-\><C-N><C-w>j]])
vim.keymap.set('t', '<A-k>', [[<C-\><C-N><C-w>k]])
vim.keymap.set('t', '<A-l>', [[<C-\><C-N><C-w>l]])
vim.keymap.set('n', '<A-h>', [[<C-w>h]])
vim.keymap.set('n', '<A-j>', [[<C-w>j]])
vim.keymap.set('n', '<A-k>', [[<C-w>k]])
vim.keymap.set('n', '<A-l>', [[<C-w>l]])

-- use the Vimwiki diary
vim.keymap.set('n', '<leader>dd', '<CMD>VimwikiDiaryIndex<CR>')
vim.keymap.set('n', '<leader>dm', '<CMD>VimwikiMakeDiaryNote<CR>')

-- use alt and -,= to decrease, increase split size
vim.keymap.set('n', '<A-->', [[<C-w>-]])
vim.keymap.set('n', '<A-=>', [[<C-w>+]])


