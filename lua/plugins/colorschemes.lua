return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    enabled = false,
    config = function()
      vim.cmd.colorscheme 'tokyo-night'
    end
  },
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    enabled = false,
    config = function()
      vim.cmd.colorscheme 'base16-tomorrow-night'
    end
  },
  {
    "tiagovla/tokyodark.nvim",
    enabled = false,
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)  -- calling setup is optional
      vim.cmd [[colorscheme tokyodark]]
    end,
  },
  {
    'deparr/tairiki.nvim',
    lazy = false,
    priority = 1000, -- only necessary if you use tairiki as default theme
    config = function()
      require('tairiki').setup {
        -- optional configuration here
      }
      require('tairiki').load() -- only necessary to use as default theme, has same behavior as ':colorscheme tairiki'
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  }
}
