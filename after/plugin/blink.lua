require('blink.cmp').setup {
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
    default = { 'lsp', 'path', 'snippets', 'buffer', }, -- 'lazydev' },
    -- per_filetype = { sql = { 'dadbod' } },
    providers = {
      -- dont show LuaLS require statements when lazydev has items
      -- lsp = { fallbacks = { "lazydev" } },
      -- lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
      -- dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink", },
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
              local dev_icon -- = kind_icons[ctx.source_name]
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
}

local local_lsp_conf = require('My.preload').conf.lsp or {}
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities       = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

local flags        = {
  allow_incremental_sync = true,
  debounce_text_changes = 200,
}
local servers      = {}
for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(path, ":t:r")
  servers[server_name] = true
  --enrich capabilitties with blink
  local params = vim.lsp.config[server_name]
  params.capabilities = vim.tbl_deep_extend('force', {}, capabilities, params.capabilities or {})
  params.flags = vim.tbl_deep_extend('force', {}, flags, params.flags or {})
  if local_lsp_conf[server_name] then
    params.capabilities = vim.tbl_deep_extend('force', {}, params.capabilities,
      local_lsp_conf[server_name].capabilities or {})
    params.flags = vim.tbl_deep_extend('force', {}, params.flags, local_lsp_conf[server_name].flags or {})
    params.settings = vim.tbl_deep_extend('force', {}, params.settings, local_lsp_conf[server_name].settings or {})
  end
end

vim.lsp.enable(vim.tbl_keys(servers), vim.g.lsp_autostart ~= false)

-- vim: ts=2 sts=2 sw=2 et
