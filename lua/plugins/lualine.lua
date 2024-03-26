local clients_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local msg = '¯\\_(ツ)_/¯'
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return msg
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local opts = {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
}
local function add_left1(spec)
  table.insert(opts.sections.lualine_a, spec)
end
local function add_left2(spec)
  table.insert(opts.sections.lualine_b, spec)
end
local function add_left3(spec)
  table.insert(opts.sections.lualine_c, spec)
end
local function add_right1(spec)
  table.insert(opts.sections.lualine_x, spec)
end
local function add_right2(spec)
  table.insert(opts.sections.lualine_y, spec)
end
local function add_right3(spec)
  table.insert(opts.sections.lualine_z, spec)
end

local function center_align()
  add_left3('%=')
end

add_left1('mode')
add_left2({
  clients_lsp,
  icon = ' ',
  color = { fg = '#ffffff', gui = 'bold' },
  cond = conditions.buffer_not_empty,
})
add_left2({
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
})

center_align()
add_left3({
  'filetype',
  icon_only = true,
  separator = '',
  padding = {
    right = 0,
    left = 1
  }
})
add_left3({
  'filename',
  path = 1,
  file_status = true,
  cond = conditions.buffer_not_empty,
})

add_right2({
  'diff',
  symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
})
add_right2('branch')
add_right3('progress')
add_right3('location')


vim.o.showmode = false

return {
  'nvim-lualine/lualine.nvim',
  opts = opts
}
