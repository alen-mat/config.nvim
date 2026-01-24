require("oil").setup {
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  keymaps = {
    ["<C-h>"] = "actions.select_split",
    ["<C-p>"] = "actions.preview",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
  },
  view_options = {
    show_hidden = true,
  },
}

vim.keymap.set("n", "<leader>0", "<CMD>Oil<CR>")

-- vim: ts=2 sts=2 sw=2 et
