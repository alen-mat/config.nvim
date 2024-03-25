vim.bo.expandtab = true
vim.o.smarttab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4

vim.wo.wrap = false
vim.o.sidescroll = 5
vim.o.sidescrolloff = 2
vim.bocolorcolumn = 100

--nnoremap <buffer><silent> <space>pf <cmd>Pytest file<CR>
--nnoremap <buffer><silent> <space>pc <cmd>Pytest function<CR>
--nnoremap <buffer><silent> <space>pm <cmd>Pytest method<CR>
--nnoremap <buffer><silent> <space>ps <cmd>Pytest session<CR>

local out_in_pp = require("My.utils").out_in_pp
vim.keymap.set('n', '<F5>', function()
  out_in_pp({ "python", "-u", vim.fn.expand('%') })
end, { desc = 'run file', silent = true })
