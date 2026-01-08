local utils = require("My.utils")
local client_lsp = require("My.utils").clients_lsp

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
    -- theme = 'tokyonight',
    component_separators = '',
    section_separators = '',
    globalstatus = true,
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
  'diagnostics',
  sources = { 'nvim_workspace_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
})

center_align()
-- add_left3({
--   'filetype',
--   icon_only = true,
--   separator = '',
--   padding = {
--     right = 0,
--     left = 1
--   }
-- })
add_left3(
  function()
    local cwd =  vim.loop.cwd()
    local pre = ''
    local pth = ''
    if vim.bo.filetype == 'oil' then
      pth = require('oil').get_current_dir() or ''
      pre = 'Oil::'
    elseif vim.bo.filetype == 'TelescopePrompt' then
      pre = '::Telescope::'
    else
      pth = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
    end
    local limited_s, count = string.gsub(pth, cwd, '[$pwd]')
    return pre..limited_s
  end)

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

return {
  {
    'nvim-lualine/lualine.nvim',
    event = "User DrawNativeStatus",
    opts = opts,
  },
  {
    'b0o/incline.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- event = 'VeryLazy',
    event = 'VeryLazy',
    config = function()
      local helpers = require 'incline.helpers'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          if filename == '' then
            filename = '[No Name]'
          end
          if vim.bo.filetype == 'oil' then
            ft_icon, ft_color = '', '#AC6790'
            filename = 'Oil'
          end
          local modified = vim.bo[props.buf].modified and '[+]' or ''
          return {
            modified,
            ' ',
            utils.get_diagnostic_label(props),
            ft_icon and { ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename },
            ' ',
          }
        end,
      }
    end,
  },
}
