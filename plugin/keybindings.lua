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
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run)

vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
-- disble keys
local keys = {
  ["<Left>"] = { "i", "v", "n" },
  ["<Right>"] = { "i", "v", "n" },
  ["<Up>"] = { "i", "v", "n" },
  ["<Down>"] = { "i", "v", "n" },
}
for _key, _modes in pairs(keys) do
  vim.keymap.set(_modes, _key, function()
    print('nope')
  end)
end

vim.keymap.set('n', '<A-h>', function()
  vim.cmd.wincmd('h')
end, { desc = 'Move focus to left pane' })
vim.keymap.set('n', '<A-j>', function()
  vim.cmd.wincmd('j')
end, { desc = 'Move focus to bottom pane' })
vim.keymap.set('n', '<A-k>', function()
  vim.cmd.wincmd('k')
end, { desc = 'Move focus to top pane' })
vim.keymap.set('n', '<A-l>', function()
  vim.cmd.wincmd('l')
end, { desc = 'Move focus to right pane' })

vim.keymap.set('n', '<A-C-h>', function()
  vim.cmd([[vertical resize -1]])
end, { desc = 'Move focus to left pane' })
vim.keymap.set('n', '<A-C-j>', function()
  vim.cmd.resize('+1')
end, { desc = 'Move focus to bottom pane' })
vim.keymap.set('n', '<A-C-k>', function()
  vim.cmd.resize('-1')
end, { desc = 'Move focus to top pane' })
vim.keymap.set('n', '<A-C-l>', function()
  vim.cmd([[vertical resize +1]])
end, { desc = 'Move focus to right pane' })



