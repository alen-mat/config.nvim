local function on_init(client, result)
  if client:supports_method("textDocument/signatureHelp") then
    client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
  end

  if result and result.offsetEncoding then
    client.offset_encoding = result.offsetEncoding
  end
end

local lsp_group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    ---@diagnostic disable-next-line: undefined-field
    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { noremap = true, silent = true, buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    nmap('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<space>ll', vim.lsp.codelens.run, '[Code] [L]ense')
    nmap("<leader>D", vim.diagnostic.open_float, '[V]iew [D]iagnostic')

    vim.keymap.set('n', '<leader>sd', function()
      require('telescope.builtin').diagnostics(require('telescope.themes').get_ivy())
    end, { desc = '[S]earch [D]iagnostics' })

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

    nmap('K', function()
      vim.lsp.buf.hover { border = "single", max_height = 25, max_width = 120 }
    end, "Hover documentation")

    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      if vim.lsp.buf.format then
        vim.lsp.buf.format()
      elseif vim.lsp.buf.formatting then
        vim.lsp.buf.formatting()
      end
    end, { desc = 'Format current buffer with LSP' })

    if client then
      vim.keymap.set('n', '<leader>sR', function()
        require('telescope.builtin').find_files { cwd = client.config.root_dir }
      end, { desc = '[S]earch File from lsp [R]oot' })

      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true)
        nmap('<leader>lh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, '[T]oggle Inlay [H]ints')
      end
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
      if client:supports_method("textDocument/foldingRange") then
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = lsp_group,
  callback = function(args)
    local buf = args.buf
    vim.b[buf].lsp = nil
    vim.api.nvim_clear_autocmds({ group = lsp_group, buffer = buf })
  end,
})


vim.lsp.config("*", { on_init = on_init, workspace_required = true })
-- vim: ts=2 sts=2 sw=2 et
