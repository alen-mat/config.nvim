local dap = require("dap")
local utils = require("My.utils")

-- configure codelldb adapter
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

-- setup a debugger config for zig projects
dap.configurations.zig = {
  {
    name = 'Launch',
    type = 'codelldb',
    request = 'launch',
    program = '${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}


vim.keymap.set('n', '<F6>', function()
  local customDap = dap.configurations.zig
  customDap[1].request = 'attach'
  utils.on_telescope({
    telescope = {},
    cmd = { "ps", "axo", "pid,pcpu,cmd" },
    on_enter = function(selected_entry)
      local pid = selected_entry[1]:match("%S+")
      print(pid)
      dap.run({
        name = 'Launch',
        type = 'codelldb',
        request = 'attach',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        pid = pid,
        args = {},
      })
    end
  })
end, { desc = 'Debug: existing process' })
