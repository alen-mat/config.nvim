vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2


local cfwp = vim.api.nvim_buf_get_name(0)
local f = cfwp:match("^.+/(.+)$")
local dir = cfwp:match("(.*/)")
local fname = f:match("(.+)%..+")
local of = dir .. fname .. ".out"


local prog = "clang++"
local flag = '-Wall -Wextra -std=c++11 ' ---O2'
local command = string.format('%s %s %s -o %s && %s', prog, flag, cfwp, of, of)



vim.keymap.set('n', '<F5>', ':!zellij run -f -n "compile and run" -- fish -c "' .. command .. '"<CR>', { desc = 'run file', silent = true })
