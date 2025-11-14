-- Disable all link underlines
-- This file ensures no links have underlines in any file type

local function remove_underlines()
  vim.cmd([[
    hi! Underlined gui=NONE guisp=NONE guifg=#96CBFE
    hi! @markup.link gui=NONE guisp=NONE guifg=#96CBFE
    hi! @markup.link.url gui=NONE guisp=NONE guifg=#C6C5FE
    hi! @markup.link.label gui=NONE guisp=NONE guifg=#96CBFE
    hi! @markup.link.text gui=NONE guisp=NONE guifg=#96CBFE
    hi! htmlLink gui=NONE guisp=NONE guifg=#96CBFE
    hi! mkdLink gui=NONE guisp=NONE guifg=#96CBFE
    hi! mkdURL gui=NONE guisp=NONE guifg=#C6C5FE
    hi! markdownUrl gui=NONE guisp=NONE guifg=#C6C5FE
    hi! markdownLink gui=NONE guisp=NONE guifg=#96CBFE
    hi! markdownLinkText gui=NONE guisp=NONE guifg=#96CBFE
  ]])
end

-- Run immediately
remove_underlines()

-- Run after colorscheme loads
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = remove_underlines,
})

-- Run after syntax loads
vim.api.nvim_create_autocmd('Syntax', {
  pattern = '*',
  callback = remove_underlines,
})

-- Run when entering buffers
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
  pattern = '*',
  callback = remove_underlines,
})
