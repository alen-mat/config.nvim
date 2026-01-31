--https://github.com/gpanders/dotfiles/blob/master/.config/nvim/fnl/statusline.fnl
local function diagnostics()
  local diags = vim.diagnostic.get(0, {
    severity = { min = vim.diagnostic.severity.WARN },
  })

  local num_errors = 0
  for _, v in ipairs(diags) do
    if v.severity == vim.diagnostic.severity.ERROR then
      num_errors = num_errors + 1
    end
  end

  local num_warnings = #diags - num_errors

  if num_errors == 0 and num_warnings == 0 then
    return ""
  elseif num_warnings == 0 then
    return string.format("E: %d ", num_errors)
  elseif num_errors == 0 then
    return string.format("W: %d ", num_warnings)
  else
    return string.format("E: %d W: %d ", num_errors, num_warnings)
  end
end
local function path1()
  local cwd = vim.loop.cwd()
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
  return pre .. limited_s
end

local function filename(buf, fancy)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    name = "Untitled"
  else
    name = name:gsub("%%", "%%%%")
  end

  local fname = vim.fn.fnamemodify(name, ":~:.")
  local parent = fname:match("^(.*/)")
  local tail = vim.fn.fnamemodify(name, ":t")

  local parent_hl, tail_hl
  if vim.bo[buf].modified then
    parent_hl, tail_hl = "%1*", "%1*"
  elseif fancy then
    parent_hl, tail_hl = "%2*", "%3*"
  else
    parent_hl, tail_hl = "", ""
  end

  return string.format(
    "%s %%<%s%s%s %%*",
    parent_hl,
    parent or "",
    tail_hl,
    tail
  )
end

local function tabline()
  local current = vim.fn.tabpagenr()
  local items = {}

  for i = 1, vim.fn.tabpagenr("$") do
    local hi = (i == current) and "TabLineSel" or "TabLine"
    local cwd = vim.fn.getcwd(-1, i)
    cwd = vim.fn.fnamemodify(cwd, ":~")
    cwd = vim.fn.pathshorten(cwd)

    table.insert(
      items,
      string.format("%%#%s#%%%dT %d %s ", hi, i, i, cwd)
    )
  end

  table.insert(items, "%#TabLineFill#%T")
  return table.concat(items)
end

local function statusline()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  local term = vim.bo[buf].buftype == "terminal"
  local curwin = tonumber(vim.g.actual_curwin) == win
  local fancy = curwin and not term

  local items = {
    '[' .. vim.api.nvim_get_mode().mode .. ']',
    vim.v.this_session ~= "" and " $" or "",
    "%=",
    -- filename(buf, fancy),
    path1(),
    vim.bo[buf].readonly and "%r " or "",
    vim.wo.previewwindow and "%w " or "",
    "%=",
    diagnostics(),
    fancy and "%4*" or "",
  }

  if vim.bo[buf].modifiable and not vim.bo[buf].readonly then
    local t = {}

    local ff = vim.bo[buf].fileformat
    if ff ~= "unix" then
      table.insert(t, ff == "dos" and "CRLF" or "CR")
    end

    local fenc = vim.bo[buf].fileencoding
    if fenc ~= "" and fenc ~= "utf-8" then
      table.insert(t, fenc)
    end

    if #t > 0 then
      table.insert(items, string.format(" %s ", table.concat(t, " ")))
    end
  end

  table.insert(items, fancy and "%8*" or "")

  local ft = vim.bo[buf].filetype
  if ft ~= "" then
    local client = vim.b.lsp_client
    if client then
      table.insert(items, string.format(" %s/%s ", ft, client))
    else
      table.insert(items, string.format(" %s ", ft))
    end
  end

  table.insert(items, fancy and "%9*" or "")
  table.insert(items, " %l:%c %P ")

  return table.concat(items)
end

return {
  statusline = statusline,
  tabline = tabline,
}

-- vim: ts=2 sts=2 sw=2 et
