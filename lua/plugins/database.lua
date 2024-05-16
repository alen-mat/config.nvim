return {
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-completion",
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "kndndrj/nvim-dbee",
    enabled = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
      require("dbee").install()
    end,
    config = function()
      local source = require "dbee.sources"
      local my_db_source = {}
      --local s = source.MemorySource:new({
      --  ---@diagnostic disable-next-line: missing-fields
      --  {
      --    type = "",
      --    name = "",
      --    url = "",
      --  },
      --}, "")
      --table.insert(my_db_source, s)
      require("dbee").setup {
        sources = my_db_source,
      }
      require "custom.dbee"
    end,
  },
}
