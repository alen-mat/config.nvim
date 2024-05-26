return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'folke/neodev.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

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
    require('My.lsp')
  end
}
