M = {}

M.open_visual_selection =function()
 -- get visual selection
  local _, ls, cs = table.unpack(vim.fn.getpos("'<"))
  local _, le, ce = table.unpack(vim.fn.getpos("'>"))

  local lines = vim.fn.getline(ls, le)
  if #lines == 0 then return end

  -- trim selection to exact columns
  lines[#lines] = string.sub(lines[#lines], 1, ce)
  lines[1] = string.sub(lines[1], cs)

  local selection = table.concat(lines, ""):gsub("%s+$", "")
  if selection == "" then return end

  local filename, lnum, col = selection:match("^(.-):(%d+):(%d+)$")
  if not filename then
    filename, lnum = selection:match("^(.-):(%d+)$")
  end

  filename = filename or selection
  lnum = tonumber(lnum)
  col = tonumber(col)

  if not vim.loop.fs_stat(filename) then
    vim.notify(
      ("File not found: %s"):format(filename),
      vim.log.levels.WARN,
      {}
    )
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(filename))
  if lnum then
    -- Neovim columns are 0-indexed
    vim.api.nvim_win_set_cursor(0, { lnum, (col or 1) - 1 })
  end
end
return M

-- vim: ts=2 sts=2 sw=2 et
