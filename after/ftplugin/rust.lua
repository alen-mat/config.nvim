-- Don't do comment stuffs when I use o/O
vim.opt_local.formatoptions:remove "o"

local utils = require("My.utils")

vim.keymap.set('n', '<F10>', function()
  local client = utils.clients_lsp()
  if client then
    utils.out_in_pp("cargo", {"run"},client.config.root_dir)
  end
end, { desc = 'run file', silent = true })
