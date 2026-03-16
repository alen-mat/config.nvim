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
  ruff = { enabled = true, },
  jedi = { extra_paths = { "src" } },
  --- disble
  autopep8 = { enabled = false },
  isort = { enabled = false },
  pycodestyle = { enabled = false },
  pyflakes = { enabled = false },
  mccabe = { enabled = false },
  flake8 = { enabled = false },      -- Add this just in case
  yapf = { enabled = false },
}
for pn, pc in pairs(plugin_config) do
  -- if vim.fn.exepath(pn) then
  base_config.settings.pylsp.plugins[pn] = pc
  -- end
end
return base_config
-- vim: ts=2 sts=2 sw=2 et
