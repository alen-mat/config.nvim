if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
end

vim.wo.number = true
vim.opt.textwidth = 80
vim.opt.colorcolumn = '81'
vim.o.confirm = true
vim.o.breakindent = true
vim.o.cursorlineopt = 'number'
vim.o.jumpoptions='view'
vim.o.foldlevelstart = 99 -- maybe not
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars:append({
  precedes = "<",
  extends = ">"
})
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.smarttab = true
vim.opt.sidescroll = 5
vim.opt.sidescrolloff = 2
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.o.termguicolors = true
vim.opt.pumheight = 10
vim.opt.pumblend = 0
vim.opt.pumborder = "rounded"
vim.opt.winborder = "rounded"
vim.opt.smoothscroll = true
vim.opt.splitright = true

vim.wo.wrap = true
vim.opt.wrap = true

vim.opt.scrolloff = 8
vim.opt.wildignore = vim.opt.wildignore + "*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*"

vim.o.cursorline = true

vim.o.completeopt = 'menu,menuone,popup,noselect,noinsert,fuzzy,preview'
vim.o.conceallevel = 2

vim.o.showmode = false

vim.opt.statuscolumn = "%s%=%l%{%&nu||&rnu?'%#WinSeparator#│':''%}"
vim.opt.statusline = "%{%v:lua.require'statusline'.statusline()%}"
vim.opt.tabline    = "%!v:lua.require'statusline'.tabline()"

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]])
vim.cmd([[aunmenu PopUp.-2-]])
vim.cmd([[vmenu <silent> PopUp.Open\ File :lua require('helpers').open_visual_selection()<CR>]])

vim.api.nvim_set_hl(0, 'WinSeparator' , { fg = '#61276b'})
vim.g.markdown_fenced_languages = {
  "python",
  "bash=sh",
  "javascript",
  "js=javascript",
  "json=javascript",
  "typescript",
  "ts=typescript",
}

vim.opt.foldtext = ''
vim.opt.fillchars:append({
  fold = '-'
})

if os.getenv("TERM_PROGRAM") == "WezTerm" and (not vim.g.neovide) then
  -- vim.o.laststatus = 0
  -- vim.opt.cmdheight = 0
  --require('statusline').init()
else
  vim.o.laststatus = 3
  vim.api.nvim_exec_autocmds("User", {
    pattern = "DrawNativeStatus",
    data = {}, -- delivered to the callback as args.data
  })
end

if vim.g.neovide then
  vim.g.neovide_refresh_rate_idle = 5
  if os.getenv("XDG_SESSION_TYPE") == "wayland" then
    vim.o.guifont = "JetBrains Mono:h11:i:#e-subpixelantialias:#h-none"
  else
    vim.o.guifont = "JetBrains Mono:h8:i:#e-subpixelantialias:#h-none"
  end
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_opacity = 0.9
  vim.g.transparency = 0.9
  local alpha = function()
    return string.format("%x", math.floor(255 * vim.g.transparency) )
  end
  vim.g.neovide_background_color = "#0f1117" .. alpha()
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_confirm_quit = true
end

-- vim: ts=2 sts=2 sw=2 et
