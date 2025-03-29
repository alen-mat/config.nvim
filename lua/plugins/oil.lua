return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = "actions.select_split",
          ["<C-p>"] = "actions.preview",
        },
        view_options = {
          show_hidden = true,
        },
      }

    end,
  },
{ 'echasnovski/mini.files', version = false,
    config = function ()
      require('mini.files').setup()
      vim.keymap.set("n", "<leader>0", require("mini.files").open)
    end
  },
}
