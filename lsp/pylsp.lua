return {
  cmd = { 'pyls' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
  },
  single_file_support = true,
}
-- vim: ts=2 sts=2 sw=2 et
