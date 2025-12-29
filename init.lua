vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install lazy
local term_prg = os.getenv("TERM_PROGRAM")
if term_prg and term_prg == 'WezTerm' then
  vim.g.wezterm = true
end
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "plugins" } })

-- vim: ts=2 sts=2 sw=2 et
