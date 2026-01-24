return {
  filetypes = { "lua" },
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json" },
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
