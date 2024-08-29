local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local cwd = vim.fn.getcwd()

local params = {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        enable = true,
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


if endswith(cwd, ".config/nvim") then
  for _, v in pairs(vim.api.nvim_get_runtime_file('', true)) do
    table.insert(params.settings.Lua.workspace.library, v)
  end
  params.settings.Lua.diagnostics.globals = { 'vim' }
  params.settings.Lua.workspace.checkThirdParty = false
elseif endswith(cwd, ".config/awesome") then
  table.insert(params.settings.Lua.workspace.library, '/usr/share/awesome/lib/')
  local handle = io.popen('find /usr/share/awesome/lib -type d')
  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    for file in result:gmatch("([^\n]*)\n?") do
      table.insert(params.settings.Lua.workspace.library, file)
    end
  end
  params.settings.Lua.diagnostics.globals = { 'awesome', 'screen', 'client' ,'tags'}
end

return { params = params }

-- vim: ts=2 sts=2 sw=2 et
