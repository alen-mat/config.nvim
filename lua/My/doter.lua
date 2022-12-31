--- inspired from plugin :  axkirillov /easypick.nvim 
local telescope_pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local themes = require "telescope.themes"


local _config = '/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME '
local handle = io.popen(_config .. 'ls-tree --full-tree -r --name-only HEAD')

if (handle == nil) then
	print('Command failed')
	return
end

local base_dir_handle = io.popen(_config .. 'rev-parse --show-toplevel')
if (base_dir_handle == nil) then
	print('Can\'t find base dir')
	return
end
local base_dir = base_dir_handle:read("*a")
-- remove | from  the shell output
base_dir = base_dir:sub(1, -2)
local result = handle:read("*a")

handle:close()

local files = {}
local opts = themes.get_dropdown({})

for token in string.gmatch(result, "[^%c]+") do
	table.insert(files, token)
end
local entry_maker = function(entry)
	return {
		value = base_dir .. '/' .. entry,
		display = base_dir .. '/' .. entry,
		ordinal = entry,
	}
end

local my_picker = telescope_pickers.new(opts, {
	prompt_title = '.dotfiles',
	finder = finders.new_table {
		results = files,
		entry_maker = entry_maker,
	},
	sorter = conf.generic_sorter(opts),
})

return my_picker


