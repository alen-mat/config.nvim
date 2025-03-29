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
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Leet",
    opts = {
      lang = "python3",
      injector = {
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", "using namespace std;" },
          after = "int main() {}",
        },
        ["java"] = {
          before = "import java.util.*;",
        },
        ["python3"] = {
          before = "from typing import List",
          after = "def main():"
        },
      }
      -- configuration goes here
    }
  },
  -- {
  --   'mrcjkb/haskell-tools.nvim',
  --   version = '^3', -- Recommended
  --   ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject', 'hs' },
  -- }
  {
    'jbyuki/nabla.nvim',
    config = function()
      local nabla = require("nabla")
      nabla.enable_virt()
      vim.keymap.set('n', '<leader>lp', nabla.popup , { desc = 'run file', silent = true })
    end
  }
}
