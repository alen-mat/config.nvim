-- Automatically reload the file if it is changed outside of Nvim, see https://unix.stackexchange.com/a/383044/221410.
-- It seems that `checktime` does not work in command line. We need to check if we are in command line before executing this command,
-- see also https://vi.stackexchange.com/a/20397/15292 .

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("auto_read", { clear = true }),
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "nvim-config" })
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup('buf-Write-pre-lsp-autofmt', { clear = true }),
  pattern = { "zig" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup('buf-Write-pre-lsp-fmt', { clear = true }),
  pattern = { "zig" },
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})

--https://www.reddit.com/r/neovim/comments/1i2xw2m/share_your_favorite_autocmds/
--useful^^^^

vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = vim.api.nvim_create_augroup("hl_toggle", { clear = true }),
  callback = function()
    vim.wo.winhighlight = ""
  end,
})

-- vim: ts=2 sts=2 sw=2 et
