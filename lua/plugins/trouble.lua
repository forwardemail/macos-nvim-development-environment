--[[
  Trouble.nvim - Diagnostic List Window
  
  Provides a pretty diagnostic list similar to old Vim quickfix/location list
  Features:
  - Navigate diagnostics with j/k
  - Press Enter to jump to diagnostic location
  - Shows full error messages
  - Tree view with file grouping
]]

return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
  opts = {
    focus = true, -- Focus the trouble window when opened
    follow = true, -- Follow the current item
    auto_close = false, -- Don't auto close when there are no items
    auto_refresh = true, -- Auto refresh when diagnostics change
    modes = {
      diagnostics = {
        auto_open = false, -- Don't auto open on diagnostic changes
        auto_jump = false, -- Don't auto jump when opening
      },
    },
  },
}
