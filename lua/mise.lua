local M = {
  env_state = {}
}
M.run = function()
  local state = {}
  local cwd = vim.fn.getcwd()
  for item in ipairs(M.env_state) do
    vim.env[item] = nil
  end
  vim.fn.jobstart('mise env --json --cd ' .. cwd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
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
    end,
    on_stderr = function(_, data)
      print('Mise : Errored')
    end,
    on_exit = vim.schedule_wrap(
      function(j, exitcode)
        if exitcode == 0 then
          local json = vim.fn.json_decode(state)
          for i, item in pairs(json) do
            vim.env[i] = item
            if i ~= 'PATH' then
              table.insert(M.env_state, i)
            end
          end
        end
      end),
  })
end
return M

-- vim: ts=2 sts=2 sw=2 et
