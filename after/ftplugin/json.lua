vim.api.nvim_buf_create_user_command(0, 'Format', function(_)
  vim.cmd('%!jq .')
end, { desc = 'Format current buffer with LSP' })
