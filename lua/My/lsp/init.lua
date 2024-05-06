require('fidget').setup()
local lsp_config = require('lspconfig')

local flags = {
  allow_incremental_sync = true,
  debounce_text_changes = 200,
}

local servers = {
  'clangd',
  'rust_analyzer',
  'pyright',
  --'tsserver',
  'lua_ls',
  --'gopls',
  -- 'java_language_server',
  'jdtls',
  --'hls',
}

local server_config_override = {
  lua_ls = 'My.lsp.lua_ls',
  jdtls = 'My.lsp.jtdls',
  rust_analyzer = 'My.lsp.rust_analyzer',
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
  callback = function(event)
    --require('vim.lsp.codelens.refresh')
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { noremap = true, silent = true, buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<space>cl', vim.lsp.codelens.run, '[Code] [L]ense')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

    --nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap("<leader>vd", vim.diagnostic.open_float, '[V]iew [D]iagnostic')

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

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
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      nmap('<leader>th', function()
        vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
      end, '[T]oggle Inlay [H]ints')
    end

    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      if vim.lsp.buf.format then
        vim.lsp.buf.format()
      elseif vim.lsp.buf.formatting then
        vim.lsp.buf.formatting()
      end
    end, { desc = 'Format current buffer with LSP' })

    local config_override = server_config_override[client]
    if (config_override) then
      require(config_override).on_attach()
    end
  end,
})

require('mason').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

for _, server_name in ipairs(servers) do
  local server = {}

  local config_override = server_config_override[server_name]
  if (config_override) then
    local config = require(config_override)
    server = config.settings
  end

  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  server.flags = flags
  --setup.on_attach = server_on_attach
  lsp_config[server_name].setup(server)
end
-- vim: ts=2 sts=2 sw=2 et
