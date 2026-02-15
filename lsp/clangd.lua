return {
  cmd = { vim.fn.getenv("HOME") .. '/.lang-and-build/clangd/bin/clangd', '--background-index', '--clang-tidy', '--log=verbose' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
  },
  init_options = {
    fallbackFlags = { '-std=c++17' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
