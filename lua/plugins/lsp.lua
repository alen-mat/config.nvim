return {
  {
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
        opts = {},
      },
      'mfussenegger/nvim-jdtls'
    },
    config = function()
      if vim.opt.diff:get() then
        vim.notify("In diff-mode skipping lsp", vim.log.levels.WARN, { title = "nvim-lsp" })
        return
      end
      require('My.lsp')
    end,
  },
  {
    {
      "folke/lazydev.nvim",
      dependencies = {
        "saghen/blink.cmp",
      },
      ft = "lua",
      opts = {
        library = {
          {
            path = "${3rd}/luv/library",
            words = { "vim%.uv" },
            "LazyVim",
            { path = "LazyVim",                   words = { "LazyVim" } },
            { path = "wezterm-types",             mods = { "wezterm" } },
            { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
          },
        },
        enabled = function(root_dir)
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end,
      },
    }
  }
}
