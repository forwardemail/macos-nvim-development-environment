-- Auto-open Trouble diagnostics window on save when diagnostics appear
-- Uses polling approach since DiagnosticChanged event is unreliable
-- Features:
-- - Auto-open Trouble when diagnostics appear after save
-- - Auto-refresh Trouble on every save
-- - Focus stays in code window (Trouble opens but doesn't steal focus)

local M = {}

-- Track which buffers are currently polling (just boolean flags, no timer IDs)
local polling_buffers = {}

-- Check if Trouble diagnostics window is open
local function is_trouble_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'trouble' then
      return true
    end
  end
  return false
end

-- Poll for diagnostics and open/update Trouble when found
local function poll_for_diagnostics(bufnr, max_attempts)
  -- Mark this buffer as polling
  polling_buffers[bufnr] = true
  
  local attempts = 0
  
  local function check()
    attempts = attempts + 1
    
    -- Stop if buffer is no longer valid
    if not vim.api.nvim_buf_is_valid(bufnr) then
      polling_buffers[bufnr] = nil
      return
    end
    
    -- Stop if not the current buffer anymore
    if bufnr ~= vim.api.nvim_get_current_buf() then
      polling_buffers[bufnr] = nil
      return
    end
    
    -- Stop if another poll started for this buffer
    if not polling_buffers[bufnr] then
      return
    end
    
    -- Check for diagnostics
    local diagnostics = vim.diagnostic.get(bufnr, { severity = { min = vim.diagnostic.severity.WARN } })
    
    if #diagnostics > 0 then
      -- Found diagnostics! Always open/refresh Trouble
      polling_buffers[bufnr] = nil
      
      -- Always open Trouble diagnostics for current buffer
      vim.cmd(string.format('Trouble diagnostics open filter.buf=%d', bufnr))
      
    elseif attempts >= max_attempts then
      -- Max attempts reached, no diagnostics found
      polling_buffers[bufnr] = nil
      
      -- Close Trouble if it's open (all errors fixed)
      if is_trouble_open() then
        vim.cmd('Trouble diagnostics close')
      end
      
    else
      -- Keep polling - don't store the return value!
      vim.defer_fn(check, 100)
    end
  end
  
  -- Start polling
  check()
end

-- Setup autocmd to start polling on save
function M.setup()
  local augroup = vim.api.nvim_create_augroup('DiagnosticAutoOpen', { clear = true })
  
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = augroup,
    pattern = '*',
    callback = function(args)
      local bufnr = args.buf
      
      -- Cancel any existing poll for this buffer by clearing the flag
      -- The polling function will stop itself when it sees the flag is cleared
      polling_buffers[bufnr] = nil
      
      -- Start new polling (max 30 attempts = 3 seconds)
      poll_for_diagnostics(bufnr, 30)
    end,
    desc = 'Poll for diagnostics and auto-open/refresh/close Trouble after save',
  })
end

return M
