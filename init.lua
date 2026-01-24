require('My.preload').init()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/saghen/blink.cmp" }
})


vim.cmd.colorscheme 'kanagawa-wave'

require("fidget").setup( )
-- vim: ts=2 sts=2 sw=2 et
