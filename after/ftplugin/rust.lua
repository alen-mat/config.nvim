vim.opt_local.formatoptions:remove "o"

local utils = require("My.utils")

vim.keymap.set('n', '<F10>', function()
  local client = utils.clients_lsp()
  if client then
    utils.out_in_pp("cargo", {"build"}, client.config.root_dir)
  end
end, { desc = 'Build Project', silent = true })
