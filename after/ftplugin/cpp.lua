vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

vim.keymap.set('n', '<F4>', function()
   require("utils").out_in_pp('make')
end, { desc = 'Compile', silent = true })

vim.keymap.set('n', '<F5>', function()
   require("utils").out_in_pp('make',{'run'})
end, { desc = 'Run', silent = true })
-- vim: ts=2 sts=2 sw=2 et
