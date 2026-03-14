local base_config = {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
  },
  single_file_support = true,
  settings = {
    pylsp = {
      plugins = {}
    }
  }
}
local plugin_config = {
  mypy = { enabled = true, report_progress = true, live_mode = true, },
  mccabe = { enabled = false },
  autopep8 = { enabled = true},
  isort = { enabled = true, },
  jedi={extra_paths = {"src"}}
}
for pn, pc in pairs(plugin_config) do
  -- if vim.fn.exepath(pn) then
  base_config.settings.pylsp.plugins[pn] = pc
  -- end
end
return base_config
-- vim: ts=2 sts=2 sw=2 et
