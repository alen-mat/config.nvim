vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('term--open', { clear = true }),
  callback = function(args)
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.scrolloff = 0
  end,
})

vim.keymap.set('t', '<Leader><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Leader>st', function()
  vim.cmd([[botright new]])
  vim.cmd.wincmd('J')
  vim.cmd.term()
end, { desc = 'Move focus to left pane' })


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
