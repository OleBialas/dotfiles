return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = require('gitsigns')
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          map('n', ']c', function() gs.nav_hunk('next') end, 'next git hunk')
          map('n', '[c', function() gs.nav_hunk('prev') end, 'prev git hunk')

          map('n', '<leader>gs', gs.stage_hunk, 'git [s]tage hunk')
          map('n', '<leader>gr', gs.reset_hunk, 'git [r]eset hunk')
          map('n', '<leader>gp', gs.preview_hunk, 'git [p]review hunk')
          map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'git [b]lame line')
          map('n', '<leader>gd', gs.diffthis, 'git [d]iff')
          map('n', '<leader>gtb', gs.toggle_current_line_blame, 'git [t]oggle [b]lame')
        end,
      }
    end,
  },
}
