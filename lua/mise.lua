local M = {
  sub_commands = {
    install = {},
    use = {},
  }
}
M.run = function()
  local env_state = {}
  local cwd = vim.fn.getcwd()
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
    on_exit = vim.schedule_wrap(
      function(j, exitcode)
        if exitcode == 0 then
          local json = vim.fn.json_decode(env_state)
          for env_var_name, env_var_value in pairs(json) do
            vim.env[env_var_name] = env_var_value
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
    on_exit = vim.schedule_wrap(
      function(j, exitcode)
        if exitcode == 0 then
          local json = vim.fn.json_decode(state)
          for i, item in pairs(json) do
            if not M.sub_commands.run then
              M.sub_commands.run = {}
            end
            table.insert(M.sub_commands.run, item.name)
          end
          vim.schedule(function()
            vim.api.nvim_create_user_command("Mise", function(opts)
              require("utils").out_in_pp('mise', opts.fargs)
            end, {
              nargs = "+",
              complete = function(arglead, cmdline)
                -- 1. Split by space to detect when we are "inside" a command
                local args = vim.split(cmdline, " ")
                table.remove(args, 1) -- Remove "Mise"

                local node = M.sub_commands

                -- 2. Traverse the tree based on typed arguments
                for i = 1, #args - 1 do
                  local key = args[i]
                  if type(node) == "table" and node[key] then
                    node = node[key]
                  else
                    return {} -- Path doesn't exist
                  end
                end

                -- 3. Determine candidates
                local candidates = {}
                if vim.islist(node) then
                  -- It's an array (like the one in your 'run' key)
                  candidates = node
                elseif type(node) == "table" then
                  -- It's a dictionary of subcommands
                  for k, _ in pairs(node) do
                    table.insert(candidates, k)
                  end
                end

                -- 4. Filter based on what user is typing
                return vim.tbl_filter(function(k)
                  return k:find("^" .. vim.pesc(arglead)) ~= nil
                end, candidates)
              end
            })
          end)
        end
      end),
  })
end
return M

-- vim: ts=2 sts=2 sw=2 et
