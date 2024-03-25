local utils = {}
utils.show_in_popup = function(buf_text)
  local current_windows = vim.api.nvim_get_current_win()
  local win_width = vim.api.nvim_win_get_width(current_windows)
  local win_height = vim.api.nvim_win_get_height(current_windows)

  local width = 50
  local height = 10
  local col = (win_width / 2) - (width / 2)
  local row = (win_height / 2) - (height / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local bufnr = vim.api.nvim_buf_get_number(buf)
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    anchor = 'NW',
    style = 'minimal',
    border = 'double',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_win_set_option(win, "winblend", 0)

  vim.keymap.set('n', "<leader>", function()
    vim.api.nvim_win_close(win, true)
  end, { desc = 'Close window', silent = true, nowait = true, buffer = bufnr, noremap = true })

  vim.keymap.set('n', "<ESC>", function()
    vim.api.nvim_win_close(win, true)
  end, { desc = 'Close window', silent = true, nowait = true, buffer = bufnr, noremap = true })

  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
  vim.bo[buf].readonly = true
  vim.opt_local.modifiable = false
end

utils.out_in_pp= function(command)
  local state = {}
  local add_to_state = function(data)
    if not data then
      return
    end
    for _, line in pairs(data) do
      if line ~= nil and line ~= '' then
        table.insert(state, line)
      end
    end
  end
  local jobid = vim.fn.jobstart(
    command,
    {
      on_stdout = function(chanid, data, name)
        add_to_state(data)
      end,
      on_stderr = function(chanid, data, name)
        add_to_state(data)
      end,
      on_exit = function(id, exitcode, event)
        utils.show_in_popup(state)
        print("exit, exitcode:" .. vim.inspect(exitcode))
      end,
    }
  )
  vim.fn.jobwait({ jobid })
end
return utils
-- vim: ts=2 sts=2 sw=2 et
