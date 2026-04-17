-- highlight markdown cells in jupyter/hydrogen notebooks
local function is_notebook()
  local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
  for _, line in ipairs(lines) do
    if line:match('^# ?%%%%') then return true end
  end
  return false
end

local function add_markdown_highlights()
  if not is_notebook() then return end
  local buf = vim.api.nvim_get_current_buf()
  local ns = vim.api.nvim_create_namespace('jupyter_markdown')
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local in_markdown = false

  for i, line in ipairs(lines) do
    if line:match('^# ?%%%% %[markdown%]') then
      in_markdown = true
    elseif line:match('^# ?%%%%') then
      in_markdown = false
    elseif in_markdown and line:match('^#') then
      -- strip leading '# ' and highlight as markdown
      local text = line:gsub('^# ?', '')
      vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
        virt_text = nil,
        hl_group = nil,
        -- use treesitter to parse inline markdown highlights
        sign_text = nil,
      })
      -- apply comment -> markdown color remapping
      if text:match('^#+%s') then
        vim.api.nvim_buf_add_highlight(buf, ns, '@markup.heading', i - 1, 0, -1)
      elseif text:match('^%*%*') or text:match('`') then
        vim.api.nvim_buf_add_highlight(buf, ns, '@markup.raw', i - 1, 0, -1)
      else
        vim.api.nvim_buf_add_highlight(buf, ns, '@markup.italic', i - 1, 0, -1)
      end
    elseif in_markdown and line == '' then
      -- keep going through blank lines
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged' }, {
  buffer = vim.api.nvim_get_current_buf(),
  callback = add_markdown_highlights,
})

add_markdown_highlights()
