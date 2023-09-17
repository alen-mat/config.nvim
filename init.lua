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

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> ',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

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

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}



-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/", "^target/" },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>lsd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader><leader>d', function()
  require('My.doter'):find()
end, { desc = 'List [D]otfile' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


vim.keymap.set('n', '<Left>', function()
  print('nope')
end)
vim.keymap.set('n', '<Right>', function()
  print('nope')
end)

vim.keymap.set('n', '<Up>', function()
  print('nope')
end)

vim.keymap.set('n', '<Down>', function()
  print('nope')
end)

vim.keymap.set('i', '<Left>', function()
  print('nope')
end)
vim.keymap.set('i', '<Right>', function()
  print('nope')
end)

vim.keymap.set('i', '<Up>', function()
  print('nope')
end)

vim.keymap.set('i', '<Down>', function()
  print('nope')
end)

vim.keymap.set('v', '<Left>', function()
  print('nope')
end)
vim.keymap.set('v', '<Right>', function()
  print('nope')
end)

vim.keymap.set('v', '<Up>', function()
  print('nope')
end)

vim.keymap.set('v', '<Down>', function()
  print('nope')
end)

--[[ require('lspconfig').java_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { '/home/alen/.local/share/nvim/mason/packages/java-language-server/dist/lang_server_linux.sh' },
  filetypes = { 'java','jsp' },
  -- root_dir = require('lspconfig').util.root_pattern('build.gradle', 'pom.xml', '.git'),
  settings = {
  }
} ]]

-- nvim-cmp setup


if vim.g.neovide ~= nil then
  vim.opt.guifont = { "Source Code Pro", ":h9" }
  vim.g.neovide_transparency = 0.9
  vim.g.transparency = 0.8
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
end

--vim.cmd [[colorscheme tokyonight-night]]
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
