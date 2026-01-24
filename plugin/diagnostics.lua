vim.diagnostic.config({
  virtual_lines = { current_line = true },
  virtual_text = {
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  },
  underline = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.INFO]  = "∙",
      [vim.diagnostic.severity.HINT]  = "∴",
    },
    severity = {
      min = vim.diagnostic.severity.INFO,
    },
  },
  jump = {
    on_jump = function()
      vim.diagnostic.open_float()
    end,
    wrap = false,
  },
  severity_sort = true,
  -- update_in_insert = true,
})
