local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local settings = {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = {},
      },
      workspace = {
        library = {
          '${3rd}/luv/library',
        },
      },
      telemetry = { enable = false },
    },
  },
}

local endswith = function(word, suffix)
  return word:sub(- #suffix) == suffix
end

local cwd = vim.fn.getcwd()

if endswith(cwd, ".config/nvim") then
  for k, v in pairs(vim.api.nvim_get_runtime_file('', true)) do
    table.insert(settings.settings.Lua.workspace.library, v)
  end
  settings.settings.Lua.diagnostics.globals = { 'vim' }
  settings.settings.Lua.workspace.checkThirdParty = false
elseif endswith(cwd, ".config/awesome") then
  table.insert(settings.settings.Lua.workspace.library, '/usr/share/awesome/lib/')
  local handle = io.popen('find /usr/share/awesome/lib -name "*.lua" -type f')
  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    for file in result:gmatch("([^\n]*)\n?") do
      table.insert(settings.settings.Lua.workspace.library, file)
    end
  end
  settings.settings.Lua.diagnostics.globals = { 'awesome', 'screen' }
end

return { settings = settings }

-- vim: ts=2 sts=2 sw=2 et
