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

      vim.keymap.set("n", "<leader>0", require("oil").toggle_float)
    end,
  },
}
