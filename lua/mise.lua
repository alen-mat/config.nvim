local M = {
  env_state = {},
  sub_commands = {
    install = {},
    use = {},
    run = {
      build = {},
      test = {},
      deploy = {},
    },
  }
}
M.run = function()
  local env_state = {}
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
            table.insert(env_state, line)
          end
        end
      else
        table.insert(env_state, data)
      end
    end,
    on_stderr = function(_, data)
      print('Mise env : Errored', vim.log.levels.ERROR)
      print(data)
    end,
    on_exit = vim.schedule_wrap(
      function(j, exitcode)
        if exitcode == 0 then
          local json = vim.fn.json_decode(env_state)
          for i, item in pairs(json) do
            vim.env[i] = item
            if i ~= 'PATH' then
              table.insert(M.env_state, i)
            end
          end
        end
      end),
  })

  local state = {}
  vim.fn.jobstart('mise tasks ls --json --cd ' .. cwd, {
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
      vim.notify('Mise task : Errored', vim.log.levels.ERROR)
      print(data)
    end,
    on_exit = vim.schedule_wrap(
      function(j, exitcode)
        if exitcode == 0 then
          local json = vim.fn.json_decode(state)
          for i, item in pairs(json) do
            table.insert(M.sub_commands.run, item.name)
          end
        end
      end),
  })

  local function get_keys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
      table.insert(keys, k)
    end
    return keys
  end

  vim.api.nvim_create_user_command("Mise", function(opts)
    require("utils").out_in_pp('mise', opts.fargs)
  end, {
    nargs = "+",
    complete = function(arglead, cmdline)
      local args = vim.split(cmdline, "%s+")
      table.remove(args, 1)
      if #args == 0 then
        return get_keys(M.sub_commands)
      end

      local node = M.sub_commands

      for i = 1, #args - 1 do
        node = node[args[i]]
        if type(node) ~= "table" then
          return {}
        end
      end

      return get_keys(node)
    end
  })
end
return M

-- vim: ts=2 sts=2 sw=2 et
