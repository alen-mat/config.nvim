local out_in_pp = require("My.utils").out_in_pp
vim.keymap.set('n', '<F10>', function()
  out_in_pp("zig",{ "build" })
end, { desc = 'run file', silent = true })
