local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show_and_insert', },
        ['<C-n>'] = { 'select_next' },
        ['<C-p>'] = { 'select_prev' },
        ["<C-y>"] = { "select_and_accept" },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        per_filetype = { sql = { 'dadbod' } },
        providers = {
          -- dont show LuaLS require statements when lazydev has items
          lsp = { fallbacks = { "lazydev" } },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink", },
        },
      },
      completion = {
        trigger = {
          show_on_keyword = false,
          show_on_trigger_character = false,
          show_on_insert_on_trigger_character = false,
          show_on_accept_on_trigger_character = false,
        },
        list = {
          selection = {
            preselect = false, auto_insert = false,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        menu = {
          draw = {
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local icon = ctx.kind_icon
                  local dev_icon = kind_icons[ctx.source_name]
                  if dev_icon then
                    icon = dev_icon
                  end

                  return icon .. ctx.icon_gap
                end,

                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              }
            }
          }
        }
      },
      signature = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" }
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    enabled = false,
    config = function()
      local luasnip = require 'luasnip'
      local cmp = require 'cmp'
      cmp.setup {
        completion = {
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            -- luasnip.lsp_expand(args.body)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ["<C-c>"] = cmp.mapping.complete(),
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
        formatting = {
          format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end

            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end
        }
      }
      cmp.setup.filetype({ "sql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
          { name = "lazydev",              group_index = 0 }
        },
      })

      luasnip.config.set_config {
        history = false,
        updateevents = "TextChanged,TextChangedI",
      }
    end
  }
}
