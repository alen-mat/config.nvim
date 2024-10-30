return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'folke/neodev.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    -- Useful status updates for LSP
    {
      'j-hui/fidget.nvim',
      tag = "legacy",
      opts = {
        text = {
          spinner = 'dots_pulse',
        },
      },
    },
    'mfussenegger/nvim-jdtls'
  },
  config = function()
    if vim.opt.diff:get() then
      vim.notify("In diff-mode skipping lsp", vim.log.levels.WARN, { title = "nvim-lsp" })
      return
    end
    require('My.lsp')
    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
