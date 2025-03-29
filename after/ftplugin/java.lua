vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

local utils = require("My.utils")

vim.keymap.set('n', '<F5>', function()
  local client = utils.clients_lsp()
  if client then
    utils.out_in_pp("mvn", {"-e", "-q", "-f", client.config.root_dir, "clean", "package", "exec:java" })
  end
end, { desc = 'run file', silent = true })
vim.keymap.set('n', '<F4>', function()
  local client = utils.clients_lsp()
  if client then
    utils.out_in_pp("mvn", {"-e", "-q", "-f", client.config.root_dir, "clean", "test", })
  end
end, { desc = 'run file', silent = true })
