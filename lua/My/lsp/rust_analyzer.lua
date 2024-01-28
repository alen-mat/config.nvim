local settings = {
  ['rust-analyzer'] = {
    cargo = {
      allFeatures = true,
    },
    checkOnSave = {
      allFeatures = true,
      command = 'clippy',
    },
    procMacro = {
      ignored = {
        ['async-trait'] = { 'async_trait' },
        ['napi-derive'] = { 'napi' },
        ['async-recursion'] = { 'async_recursion' },
      },
    },
  },
}
return { settings = settings }
-- vim: ts=2 sts=2 sw=2 et
