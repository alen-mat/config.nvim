return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  config = function()
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ['<C-y>'] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          { "i", "c" }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'orgmode' },
        { name = 'path' },
        { name = 'buffer' },
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
    }
    cmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })

    luasnip.config.set_config {
      history = false,
      updateevents = "TextChanged,TextChangedI",
    }
  end
}
