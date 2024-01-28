local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local settings = {
	Lua = {
		runtime = {
			-- Tell the language server which version of Lua you're using (most likely LuaJIT)
			version = 'LuaJIT',
			-- Setup your lua path
			path = runtime_path,
		},
		diagnostics = {
			globals = { 'vim' },
		},
		workspace = { library = vim.api.nvim_get_runtime_file('', true) },
		-- Do not send telemetry data containing a randomized but unique identifier
		telemetry = { enable = false },
	},
}

return { settings = settings }

-- vim: ts=2 sts=2 sw=2 et
