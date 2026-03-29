return {
  manual_install = true,
  cmd = { 'zls' },
  root_markers = {
    'build.zig',
    'build.zig.zon'
  },
  settings = {
    codelens = { enable = true },
    inlayHints = { enable = true },
    syntaxDocumentation = { enable = true },
  },
}
-- vim: ts=2 sts=2 sw=2 et
