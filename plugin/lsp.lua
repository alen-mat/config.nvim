if vim.opt.diff:get() then
  vim.notify("In diff-mode skipping lsp", vim.log.levels.WARN, { title = "nvim-lsp" })
  return
end

if vim.fn.exepath('mise') then
  require('mise').run()
end
require('lsp-setup')

-- vim: ts=2 sts=2 sw=2 et
