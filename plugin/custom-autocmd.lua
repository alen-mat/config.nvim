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

-- Resize all windows when we resize the terminal
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("win_autoresize", { clear = true }),
  desc = "autoresize windows on resizing operation",
  command = "wincmd =",
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


vim.api.nvim_create_autocmd({ 'BufAdd' }, {
  group = vim.api.nvim_create_augroup('spell-check', { clear = true }),
  callback = function(event)
    vim.api.nvim_buf_create_user_command(event.buf, 'Ssc', function(_)
      vim.opt_local.spelllang = 'en_us'
      vim.opt_local.spell = true
    end, { desc = '[S]tart [S]pell [C]heck' })
    vim.api.nvim_buf_create_user_command(event.buf, 'Scs', function(_)
      vim.opt_local.spelllang = ''
      vim.opt_local.spell = false
    end, { desc = '[S]pell [C]heck [S]top' })
  end,
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
vim.api.nvim_set_hl(0, "DimInactiveWindows", { fg = "#666666", default = true })
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = vim.api.nvim_create_augroup("hl_toggle", { clear = true }),
  callback = function()
    local ft = vim.bo.filetype
    if ft == "telescope" then
      return
    end
    local highlights = {}
    for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
      table.insert(highlights, hl .. ":DimInactiveWindows")
    end
    vim.wo.winhighlight = table.concat(highlights, ",")
  end,
})
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = vim.api.nvim_create_augroup("hl_toggle", { clear = true }),
  callback = function()
    vim.wo.winhighlight = ""
  end,
})

