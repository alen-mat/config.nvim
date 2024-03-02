return {
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
  --
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
          changedelete = { text = 'o' },
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
      --vim.cmd.colorscheme 'tokyo-night'
    end
  },
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme 'base16-tomorrow-night'
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

  -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
  'ThePrimeagen/vim-be-good',

  {
    "Dhanus3133/LeetBuddy.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("leetbuddy").setup({})
    end,
    keys = {
      { "<leader>lq", "<cmd>LBQuestions<cr>", desc = "List Questions" },
      { "<leader>ll", "<cmd>LBQuestion<cr>",  desc = "View Question" },
      { "<leader>lr", "<cmd>LBReset<cr>",     desc = "Reset Code" },
      { "<leader>lt", "<cmd>LBTest<cr>",      desc = "Run Code" },
      { "<leader>ls", "<cmd>LBSubmit<cr>",    desc = "Submit Code" },
    },
  }
}
