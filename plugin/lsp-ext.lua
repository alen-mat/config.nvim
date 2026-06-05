-- @author = Gemini 3.1 - Flash
-- Modern, high-performance lens engine for Neovim 0.12+
-- Refined to skip post-save pipeline computation if no text content changed.
local M = {}
local ns = vim.api.nvim_create_namespace("lsp_all_file_lens")
local timer = vim.uv.new_timer()
local state = {}       -- bufnr -> boolean (computed)
local save_hashes = {} -- bufnr -> string (pre-save text hash)

local BATCH_SIZE = 6
local DEBOUNCE_MS = 300

local SymbolKind = vim.lsp.protocol.SymbolKind
local INTELLIJ_ALLOWED_KINDS = {
  [SymbolKind.File]      = true, [SymbolKind.Module]   = true,
  [SymbolKind.Namespace] = true, [SymbolKind.Package]  = true,
  [SymbolKind.Class]     = true, [SymbolKind.Method]   = true,
  [SymbolKind.Property]  = true, [SymbolKind.Field]    = true,
  [SymbolKind.Interface] = true, [SymbolKind.Function] = true,
  [SymbolKind.Struct]    = true, [SymbolKind.Event]    = true,
  [SymbolKind.Operator]  = true,
}

-- Helper: Normalize loose LSP specification returns (Arrays vs Single Objects)
local function get_result_count(result)
  if not result then return 0 end
  if result.uri or result.targetUri then return 1 end
  return #result
end

-- Helper: Get exact leading whitespace string of a given line for indentation matching
local function get_line_indent(buf, line)
  local line_content = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1] or ""
  return line_content:match("^%s*") or ""
end

-- Helper: Generate a fast memory hash of the current buffer text
local function hash_buf(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return "" end
  local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
  return vim.fn.sha256(content)
end

-- Core Action: Draw virtual text cleanly above target coordinates
local function render_lens(buf, line, name, def_count, ref_count)
  if vim.api.nvim_get_current_buf() ~= buf then return end
  
  local text = string.format("󰌹 [%s] • %d def | %d ref", name, def_count, ref_count)
  local padding = get_line_indent(buf, line)

  vim.api.nvim_buf_set_extmark(buf, ns, line, 0, {
    virt_lines = { 
      { 
        { padding, "Normal" }, 
        { text, "Comment" } 
      } 
    },
    virt_lines_above = true,
    hl_mode = "combine",
    invalidate = true,
  })
end

-- Core Action: Recursively filter and build a flat target array from Document Symbol AST
local function extract_definitions(symbols)
  local defs = {}
  local function walk(items)
    for _, sym in ipairs(items) do
      if INTELLIJ_ALLOWED_KINDS[sym.kind] then
        local r = sym.selectionRange or sym.range or (sym.location and sym.location.range)
        if r then 
          table.insert(defs, { l = r.start.line, c = r.start.character, name = sym.name }) 
        end
      end
      if sym.children then walk(sym.children) end
    end
  end
  walk(symbols)
  return defs
end

-- Core Action: Manage the non-blocking throttled concurrency queue
local function process_pipeline(buf, defs)
  local idx, active = 1, 0

  local function next_batch()
    if idx > #defs or vim.api.nvim_get_current_buf() ~= buf then return end
    
    while active < BATCH_SIZE and idx <= #defs do
      local d = defs[idx]
      idx, active = idx + 1, active + 1

      local req_params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = { line = d.l, character = d.c },
      }
      
      local ref_params = vim.deepcopy(req_params)
      ref_params.context = { includeDeclaration = true }

      local ref_count, def_count = nil, nil
      
      local function check_done()
        if ref_count and def_count then
          if ref_count > 0 or def_count > 0 then
            render_lens(buf, d.l, d.name, def_count, ref_count)
          end
        end
      end

      -- Fetch references
      vim.lsp.buf_request(buf, "textDocument/references", ref_params, function(r_err, r_res)
        ref_count = (not r_err and r_res) and get_result_count(r_res) or 0
        check_done()
      end)

      -- Fetch definitions
      vim.lsp.buf_request(buf, "textDocument/definition", req_params, function(d_err, d_res)
        def_count = (not d_err and d_res) and get_result_count(d_res) or 0
        active = active - 1
        check_done()
        next_batch()
      end)
    end
  end
  
  next_batch()
end

-- Entry point: Handles guardrails and starts symbol evaluation
function M.lens(force)
  local buf = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) or (not force and state[buf]) then return end

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  vim.lsp.buf_request(buf, "textDocument/documentSymbol", params, function(err, symbols)
    if err or not symbols or vim.api.nvim_get_current_buf() ~= buf then return end

    local defs = extract_definitions(symbols)
    if #defs == 0 then return end

    state[buf] = true
    process_pipeline(buf, defs)
  end)
end

-- Automation Scheduler Layer
local function debounce(force)
  timer:stop()
  timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(function() M.lens(force) end))
end

local augroup = vim.api.nvim_create_augroup("LspLensCore", { clear = true })

-- 1. Cache the current hash of the text *right before* flushing changes to disk
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(ev)
    save_hashes[ev.buf] = hash_buf(ev.buf)
  end
})

-- 2. Trigger computation on save ONLY if the post-save hash differs from the pre-save hash
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  callback = function(ev)
    local post_hash = hash_buf(ev.buf)
    if save_hashes[ev.buf] ~= post_hash then
      debounce(true) -- Force compute: text actually changed
    end
    save_hashes[ev.buf] = nil -- Clean up transactional memory
  end
})

vim.api.nvim_create_autocmd("BufEnter", { group = augroup, callback = function() debounce(false) end })
vim.api.nvim_create_autocmd("BufWipeout", { 
  group = augroup, 
  callback = function(ev) 
    state[ev.buf] = nil 
    save_hashes[ev.buf] = nil
  end 
})

return M
-- vim: ts=2 sts=2 sw=2 et
