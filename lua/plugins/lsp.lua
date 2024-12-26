return{
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
  end,
},
  {
    {
      "folke/lazydev.nvim",
      dependencies = {
        "hrsh7th/nvim-cmp",
        "saghen/blink.cmp",
      },
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          {
            path = "${3rd}/luv/library",
            words = { "vim%.uv" },
            "LazyVim",
            -- Only load the lazyvim library when the `LazyVim` global is found
            { path = "LazyVim",                   words = { "LazyVim" } },
            -- Load the wezterm types when the `wezterm` module is required
            -- Needs `justinsgithub/wezterm-types` to be installed
            { path = "wezterm-types",             mods = { "wezterm" } },
            -- Load the xmake types when opening file named `xmake.lua`
            -- Needs `LelouchHe/xmake-luals-addon` to be installed
            { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
          },
        },
        enabled = function(root_dir)
          --return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end,
      },
      -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
    }
  }
}
