return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

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
    },
    config = function()
      require('My.lsp')
    end
  },

  --Async Jobs
  {
    "skywind3000/asyncrun.vim",
    opt = true,
    cmd = {
      "AsyncRun"
    }
  },

  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require("notify")
    end
  },
  -- Additional text objects via treesitter
  'nvim-treesitter/nvim-treesitter-textobjects',


  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      -- Gitsigns
      -- See `:help gitsigns.txt`
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd [[colorscheme tokyonight-night]]
    end
  },
  {
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    main = "ibl",
    opts = {
      indent = {
        char = "|"
      },
      whitespace = {
        remove_blankline_trail = false,
      },
      scope = { enabled = false },
    },
  },
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
  'tpope/vim-sleuth',      -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim',            branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make',   cond = vim.fn.executable 'make' == 1 },
  'ThePrimeagen/vim-be-good',
}
