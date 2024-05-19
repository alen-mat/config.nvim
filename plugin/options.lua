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
vim.api.nvim_set_hl(0, 'CursorLine', {})
vim.api.nvim_set_hl(0, 'cursorlinenr', { bold = true })

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'


