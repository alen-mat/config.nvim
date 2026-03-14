vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4

vim.opt_local.textwidth = 79
vim.opt_local.colorcolumn = "80"

local out_in_pp = require("utils").out_in_pp
vim.keymap.set('n', '<F5>', function()
  out_in_pp("python",{ "-u", vim.fn.expand('%') })
end, { desc = 'run file', silent = true })

-- Run when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Check if LSP supports formatting
    if client and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            id = client.id,
          })
        end,
      })
    end
  end,
})
