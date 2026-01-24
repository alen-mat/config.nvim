-- https://github.com/gpanders/dotfiles/blob/master/.config/nvim/plugin/scrollbar.fnl

local ns = vim.api.nvim_create_namespace("scrollbar")
local state = {}

local function on_win(_, winid, bufnr, topline, botline)
  -- Ignore floating windows
  if vim.api.nvim_win_get_config(winid).relative ~= "" then
    return false
  end

  local lines = vim.api.nvim_buf_line_count(bufnr)
  local height = vim.api.nvim_win_get_height(winid)

  if lines <= height then
    state[winid] = nil
  else
    local cells_per_line = height / lines
    local span = math.floor(0.5 + (botline - topline) * cells_per_line)
    local start = math.floor(topline + topline * cells_per_line)
    local finish = math.min(lines, start + span + 1)

    state[winid] = {
      start = start,
      ["end"] = finish,
    }
  end

  vim.api.nvim__redraw({ win = winid, valid = false })

  return state[winid] ~= nil
end

local function on_line(_, winid, bufnr, row)
  local s = state[winid]
  if not s then
    return
  end

  if s.start <= row and row < s["end"] then
    vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
      ephemeral = true,
      virt_text = { { "▐", "WinSeparator" } },
      virt_text_pos = "right_align",
      virt_text_repeat_linebreak = true,
    })
  end
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = on_win,
  on_line = on_line,
})

