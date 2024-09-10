-- autoformat when saving Python
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    command = "Black",
})

-- when previewing a markdown file, open new window
vim.cmd(
[[
function OpenMarkdownPreview (url)
    execute "silent ! firefox --new-window " . a:url
endfunction
]]
)
vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'

-- wrap lines when editing text
local group = vim.api.nvim_create_augroup("Markdown Wrap Settings", { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = {'*.md', '*.tex'},
  group = group,
  command = 'setlocal wrap'
})
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = {'*.md', '*.tex'},
  command = 'setlocal spell spelllang=en_us'
})


