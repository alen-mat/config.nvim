if vim.g.neovide ~= nil then
  vim.g.neovide_refresh_rate_idle = 5
  -- if os.getenv("XDG_SESSION_TYPE") == "wayland" then
  --   vim.opt.guifont = { "Source Code Pro", ":h12" }
  -- else
  --   vim.opt.guifont = { "Source Code Pro", ":h9" }
  -- end
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
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_confirm_quit = true
end

vim.wo.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.o.termguicolors = true

vim.wo.wrap = true
vim.opt.wrap = true

vim.opt.scrolloff = 8
vim.opt.wildignore = vim.opt.wildignore + "*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*"

vim.o.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine', {})
vim.api.nvim_set_hl(0, 'cursorlinenr', { bold = true })

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect,noinsert,preview'
vim.o.conceallevel = 2

--- LSP ---
vim.diagnostic.config({
  -- update_in_insert = true,
  virtual_lines = { current_line = true },
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})
if not vim.g.wezterm then
  vim.o.laststatus = 3
else
  vim.o.laststatus = 0
  vim.opt.cmdheight = 0
end
vim.o.showmode = false
