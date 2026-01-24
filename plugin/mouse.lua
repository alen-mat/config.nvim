-- https://github.com/gpanders/dotfiles/blob/master/.config/nvim/plugin/mouse.fnl
-- Mouse hover function
local function mouse_hover(buf, client)
  local mouse = vim.fn.getmousepos()
  local row, col, winid = mouse.line, mouse.column, mouse.winid

  if buf == vim.api.nvim_win_get_buf(winid) then
    row = row - 1  -- Lua is 0-indexed for LSP
    local lines = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)
    local line = lines[1]

    if line and col <= #line then
      local uri = vim.uri_from_bufnr(buf)
      local character = vim.str_utfindex(line, col)
      local params = {
        textDocument = { uri = uri },
        position = { line = row, character = character },
      }

      local hover = "textDocument/hover"
      local document_highlight = "textDocument/documentHighlight"

      if client:supports_method(hover, { bufnr = buf }) then
        local handler = client.handlers[hover] or vim.lsp.handlers.hover
        handler = vim.lsp.with(handler, { relative = "mouse", silent = true, border = "rounded" })
        client:request(hover, params, handler, buf)
      end

      if client:supports_method(document_highlight, { bufnr = buf }) then
        local handler = client.handlers[document_highlight] or function(_, result)
          vim.lsp.util.buf_highlight_references(buf, result or {}, client.offset_encoding)
        end

        local wrapped_handler = function(...)
          vim.lsp.util.buf_clear_references(buf)
          handler(...)
        end

        client:request(document_highlight, params, wrapped_handler, buf)
      end
    end
  end
end

-- Autocmd to attach mouse hover
vim.api.nvim_create_augroup("MouseHover", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = "MouseHover",
  callback = function(args)
    local buf = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and (
      client:supports_method("textDocument/hover", { bufnr = buf }) or
      client:supports_method("textDocument/documentHighlight", { bufnr = buf })
    ) then
      vim.keymap.set("n", "<2-LeftMouse>", function()
        mouse_hover(buf, client)
      end, { buffer = buf })
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
