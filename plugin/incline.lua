local window_group = vim.api.nvim_create_augroup("WindowEvents", { clear = true })

---@type table<number, { win: number, config:vim.api.keyset.win_config }>
local cache = {}

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = window_group,
  callback = function(ev)
    local current_win = vim.api.nvim_get_current_win()
    local file_name = vim.fn.fnamemodify(ev.file, ":t")
    if cache[current_win] then
      local title_buff = vim.api.nvim_win_get_buf(cache[current_win].win)
      vim.api.nvim_buf_set_lines(title_buff, 0, -1, true, { file_name })
      cache[current_win].config.width = #file_name + 2
      vim.api.nvim_win_set_config(cache[current_win].win, cache[current_win].config)
      vim.api.nvim_set_current_win(current_win)
    end
  end
})
vim.api.nvim_create_autocmd("WinNew", {
  group = window_group,
  callback = function(ev)
    local current_bufnr = ev.buf
    local current_win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(current_win).relative ~= "" then
      return false
    end
    if not cache[current_win] then
      local bufnr = vim.api.nvim_create_buf(false, true)
      local file_name = vim.fn.fnamemodify(ev.file, ":t")

      local window_width = vim.api.nvim_win_get_width(current_win)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { file_name })
      vim.api.nvim_set_option_value('undofile', false, { scope = 'local', buf = bufnr })
      ---@type vim.api.keyset.win_config
      local config = {
        width = #file_name + 2,
        height = 1,
        relative = "win", -- Relative to the editor screen
        anchor = "NE",
        row = 0,          -- Offset from the top
        col = window_width,
        focusable = false,
        mouse = false,
        noautocmd = true,
        win = current_win,
      }
      local winnr = vim.api.nvim_open_win(bufnr, 0, config)
      vim.api.nvim_set_option_value('number', false, { scope = 'local', win = winnr })
      vim.api.nvim_set_option_value('relativenumber', false, { scope = 'local', win = winnr })
      vim.api.nvim_set_option_value('breakindent', false, { scope = 'local', win = winnr })
      cache[current_win] = { win = winnr, config = config }
      vim.api.nvim_set_current_win(current_win)
    end
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  group = window_group,
  callback = function(ev)
    local current_win = vim.api.nvim_get_current_win()
    if cache[current_win] then
      vim.api.nvim_win_close(cache[current_win].win, false)
      cache[current_win] = nil
    end
  end,
})

vim.api.nvim_create_autocmd("WinResized", {
  group = window_group,
  callback = function(ev)
    local current_win = vim.api.nvim_get_current_win()
    local changed_windows = vim.v.event.windows
    for _, win in ipairs(changed_windows) do
      if cache[win] then
        cache[win].config.col = vim.api.nvim_win_get_width(win)
        vim.api.nvim_win_set_config(cache[win].win, cache[win].config)
      end
    end
    vim.api.nvim_set_current_win(current_win)
  end,
  -- You can add specific patterns/filters if needed
})
-- vim: ts=2 sts=2 sw=2 et
