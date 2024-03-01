-- Install lazy
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

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy').setup('plugins')


-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Relative line numbers
vim.opt.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Search highlight
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.wildignore = vim.opt.wildignore + "*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*"

vim.o.cursorline = true
vim.api.nvim_set_hl(0,'CursorLine',{})
vim.api.nvim_set_hl(0,'cursorlinenr',{bold = true})

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv'")
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv'")
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set({ 'n', 'v' }, "<leader>y", [["+y]])
vim.keymap.set('n', "<leader>Y", [["+Y]])
vim.keymap.set({ 'n', 'v' }, "<leader>p", [["+p]])
vim.keymap.set('n', "<leader>P", [["+P]])
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})



-- Enable Comment.nvim
require('Comment').setup()

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
vim.keymap.set('n', '<leader><leader>d', function()
  require('My.doter'):find()
end, { desc = 'List [D]otfile' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
-- disble keys
local keys = {
  ["<Left>"] = {"i","v","n"} ,
  ["<Right>"] = {"i","v","n"},
  ["<Up>"] = {"i","v","n"},
  ["<Down>"] = {"i","v","n"},
}
for _key, _modes in pairs(keys) do
    vim.keymap.set(_modes, _key, function()
      print('nope')
  end)
end
-- 
-- nvim-cmp setup


if vim.g.neovide ~= nil then
  vim.g.neovide_refresh_rate_idle = 5
  vim.opt.guifont = { "Source Code Pro", ":h9" }
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  local alpha = function()
    return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
  end
  vim.g.neovide_transparency = 0.8
  vim.g.transparency = 0.8
  vim.g.neovide_background_color = "#0f1117" .. alpha()
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end

-- vim: ts=2 sts=2 sw=2 et
