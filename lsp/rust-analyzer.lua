return {
  filetypes = { "rust" },
  root_markers = { "Cargo.toml" },
  cmd = {vim.fn.getenv("HOME").."/.local/share/cargo/bin/rust-analyzer"},
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      initialization_options = {
        check = { command = "clippy" }
      },
      procMacro = {
        ignored = {
          ['async-trait'] = { 'async_trait' },
          ['napi-derive'] = { 'napi' },
          ['async-recursion'] = { 'async_recursion' },
        },
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
