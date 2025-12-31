vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("my_Custom", { clear = true }),
  pattern = "DrawNativeStatus",
  desc = "Trigger for lualine",
  callback = function() end,
})
