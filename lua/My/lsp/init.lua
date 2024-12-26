require('fidget').setup()
require('mason').setup()
local lsp_config    = require('lspconfig')

local flags         = {
  allow_incremental_sync = true,
  debounce_text_changes = 200,
}

local servers       = {
  clangd = true,
  pyright = true,
  lua_ls = true,--require('My.lsp.lua_ls'),
  jdtls = require('My.lsp.jtdls'),
  rust_analyzer = require('My.lsp.rust_analyzer'),
}

servers["ocamllsp"] = {
  manual_install = true,
  cmd = { "dune", "exec", "ocamllsp" },
  settings = {
    codelens = { enable = true },
    inlayHints = { enable = true },
    syntaxDocumentation = { enable = true },
  },
  server_capabilities = {
    semanticTokensProvider = false,
  },
}
servers.zls         = {
  manual_install = true,
  cmd = { 'zls' },
  settings = {
    codelens = { enable = true },
    inlayHints = { enable = true },
    syntaxDocumentation = { enable = true },
  },
}


local servers_to_install = vim.tbl_filter(function(key)
  local t = servers[key]
  if type(t) == "table" then
    return not t.manual_install
  else
    return t
  end
end, vim.tbl_keys(servers))

local ensure_installed = {
  --"stylua",
  --"lua_ls",
  --"delve",
  -- "tailwind-language-server",
}
vim.list_extend(ensure_installed, servers_to_install)
require("mason-tool-installer").setup { ensure_installed = ensure_installed }

local basic_capabilities = vim.lsp.protocol.make_client_capabilities()
--basic_capabilities = vim.tbl_deep_extend('force', basic_capabilities, require('cmp_nvim_lsp').default_capabilities())
basic_capabilities = vim.tbl_deep_extend('force', basic_capabilities, require('blink.cmp').get_lsp_capabilities())

for server, config in pairs(servers) do
  local params = {}

  if type(config) == "table" then
    params = config.params or {}
  end

  params.capabilities = vim.tbl_deep_extend('force', {}, basic_capabilities, params.capabilities or {})
  params.flags = flags
  --setup.on_attach = server_on_attach
  lsp_config[server].setup(params)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
  callback = function(event)
    --require('vim.lsp.codelens.refresh')
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { noremap = true, silent = true, buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    nmap('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<space>ll', vim.lsp.codelens.run, '[Code] [L]ense')
    nmap("<leader>D", vim.diagnostic.open_float, '[V]iew [D]iagnostic')

    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

    nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[L]sp [I]mplementation')

    --nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ld', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    nmap('<leader>lci', function()
      require('telescope.builtin').lsp_incoming_calls(require('telescope.themes').get_ivy({}))
    end, '[L]SP [I]ncoming [C]alls')
    nmap('<leader>lco', function()
      require('telescope.builtin').lsp_outgoing_calls(require('telescope.themes').get_ivy({}))
    end, '[L]SP [O]utgoing [C]alls')

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')


    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- This may be unwanted, since they displace some of your code
    -- [Kick Start] see how theses goes
    if client then
      vim.keymap.set('n', '<leader>sR', function()
        require('telescope.builtin').find_files { cwd = client.config.root_dir }
      end, { desc = '[S]earch File from lsp [R]oot' })

      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        nmap('<leader>lh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, '[T]oggle Inlay [H]ints')
      end
    end

    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      if vim.lsp.buf.format then
        vim.lsp.buf.format()
      elseif vim.lsp.buf.formatting then
        vim.lsp.buf.formatting()
      end
    end, { desc = 'Format current buffer with LSP' })

    -- local config_override = server_config_override[client] or {}
    -- if (config_override.on_attach) then
    --   require(config_override).on_attach()
    -- end
  end,
})


-- vim: ts=2 sts=2 sw=2 et
