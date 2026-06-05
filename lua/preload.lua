M = {
  conf = {}
}
local function load_workspace_config()
  if vim.fn.filereadable('.nvimconf') then
    local file = io.open('.nvimconf', 'r')
    if not file then
      return
    end
    local file_contents = file:read("*a")
    file:close()
    local status, tbl = pcall(vim.json.decode, file_contents)
    if status then
      M.conf = tbl
    end
  end
end
local function register_autocmd()
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("my_Custom", { clear = true }),
    pattern = "DrawNativeStatus",
    desc = "Trigger for lualine",
    callback = function() end,
  })
end

M.init = function()
  load_workspace_config()
  register_autocmd()
  local local_bin = vim.fn.getenv("HOME") .. "/.local/bin"
  if not string.find(vim.env.PATH, local_bin, 1, true) then
    vim.env.PATH = local_bin .. ':' .. vim.env.PATH
  end
end
return M
-- vim: ts=2 sts=2 sw=2 et
