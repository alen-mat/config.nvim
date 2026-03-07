vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('term--open', { clear = true }),
  callback = function()
    vim.wo.scrolloff = 0
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.statuscolumn = ""
    vim.wo.signcolumn = "no"
    vim.opt.listchars = { space = " " }
  end,
})

vim.keymap.set('t', '<Leader><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Leader>st', function()
  vim.cmd([[botright new]])
  vim.cmd.wincmd('J')
  vim.cmd.term('fish')
end, { desc = 'Spawn new split terminl' })


vim.keymap.set('t', '<A-h>', function()
  vim.cmd.wincmd('h')
end, { desc = 'Move focus to left pane' })
vim.keymap.set('t', '<A-j>', function()
  vim.cmd.wincmd('j')
end, { desc = 'Move focus to bottom pane' })
vim.keymap.set('t', '<A-k>', function()
  vim.cmd.wincmd('k')
end, { desc = 'Move focus to top pane' })
vim.keymap.set('t', '<A-l>', function()
  vim.cmd.wincmd('l')
end, { desc = 'Move focus to right pane' })

-- vim: ts=2 sts=2 sw=2 et
