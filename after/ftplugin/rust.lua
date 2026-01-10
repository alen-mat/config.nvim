vim.opt_local.formatoptions:remove "o"

local utils = require("My.utils")

vim.keymap.set('n', '<F10>', function()
  local client = utils.clients_lsp()
  if client then
    local build_args = vim.g.rust_build_args or {"build"}
    utils.out_in_pp("cargo", build_args, client.config.root_dir)
  end
end, { desc = 'Build Project', silent = true })
