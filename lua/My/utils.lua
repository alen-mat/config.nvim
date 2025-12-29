local utils = {}
utils.show_in_popup = function(buf_text, opt)
  local buf_lines = buf_text
  if buf_text == 'string' then
    buf_lines = vim.split(buf_text, '\n', { plain = true })
  end

  local current_windows = vim.api.nvim_get_current_win()
  local win_width = vim.api.nvim_win_get_width(current_windows)
  local win_height = vim.api.nvim_win_get_height(current_windows)

  local width = 100
  local height = 30
  local col = (win_width / 2) - (width / 2)
  local row = (win_height / 2) - (height / 2)

  local buf = vim.api.nvim_create_buf(false, true)
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
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("winblend", 0, { win = win })

  vim.keymap.set('n', "<leader>", function()
    vim.api.nvim_win_close(win, true)
  end, { desc = 'Close window', silent = true, nowait = true, buffer = buf, noremap = true })

  vim.keymap.set('n', "<ESC>", function()
    vim.api.nvim_win_close(win, true)
  end, { desc = 'Close window', silent = true, nowait = true, buffer = buf, noremap = true })

  vim.keymap.set('n', "q", function()
    vim.api.nvim_win_close(win, true)
  end, { desc = 'Close window', silent = true, nowait = true, buffer = buf, noremap = true })

  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_lines)

  vim.bo[buf].readonly = true
  vim.opt_local.modifiable = false
end

utils.out_in_pp = function(command, args, wdir)
  local state = {}
  local add_to_state = function(data)
    if not data then
      return
    end
    if type(data) == "table" then
      for _, line in pairs(data) do
        if line ~= nil and line ~= '' then
          table.insert(state, line)
        end
      end
    else
      table.insert(state, data)
    end
  end

  local progress = require("fidget.progress")
  local Job = require('plenary.job')

  local handle = progress.handle.create({
    title = command,
    message = "Initialising",
    lsp_client = { name = "[JOB]" },
  })
  local job_opt = {
    command = command,
    args = args,
    on_start = function(j, return_val)
      handle.message = "Running"
    end,
    on_stdout = function(_, data)
      add_to_state(data)
    end,
    on_stderr = function(_, data)
      add_to_state(data)
    end,
    on_exit = vim.schedule_wrap(
      function(j, exitcode)
        utils.show_in_popup(state)
        handle.message = "Done"
        handle:finish()
        print("exit, exitcode:" .. vim.inspect(exitcode))
      end),
  }
  if wdir ~= nil then
    job_opt.cwd = wdir
  end
  Job:new(job_opt):start()
end

utils.clients_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client
    end
  end
end

utils.on_telescope = function(opts)
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions_state = require("telescope.actions.state")
  local actions = require("telescope.actions")

  local on_enter = function(prompt_bufnr)
    local selected_entry = actions_state.get_selected_entry()
    opts.on_enter(selected_entry)
    actions.close(prompt_bufnr)
  end

  pickers.new(opts.telescope, {
    prompt_title = "Process",
    finder = finders.new_oneshot_job(opts.cmd, opts.telescope),
    sorter = conf.generic_sorter(opts.telescope),
    attach_mappings = function(_, map)
      map("n", "<cr>", on_enter)
      map("i", "<cr>", on_enter)
      return true
    end,
  }):find()
end
-- to execute the function

utils.get_diagnostic_label = function(props)
  local icons = { error = '', warn = '', info = '', hint = '', }
  local label = {}

  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(
      props.buf,
      { severity = vim.diagnostic.severity[string.upper(severity)] }
    )
    if n > 0 then
      table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
    end
  end
  if #label > 0 then table.insert(label, { "┊ " }) end
  return label
end

return utils
-- vim: ts=2 sts=2 sw=2 et
