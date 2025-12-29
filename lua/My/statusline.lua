-- https://github.com/VonHeikemen/nvim-starter/blob/xx-user-plugins/lua/user/statusline.lua
-- https://github.com/Congee/nix/blob/8394e6b13bfd870925a5d750afb8475a5502db6a/config/.wezterm.lua#L245-L269
-- https://github.com/Congee/nix/blob/8394e6b13bfd870925a5d750afb8475a5502db6a/config/nvim/lua/wezterm_bar.lua#L25

local M = {}
local group = vim.api.nvim_create_augroup("Statusline", {})
M.send = function(str)
  -- uv.hrtime()
  local template = '\x1b]1337;SetUserVar=nvimStatusLine=%s\a';
  local osc = template:format(vim.base64.encode(str));
  vim.api.nvim_chan_send(vim.v.stderr, osc)
end
M.initialise = true
M.segments = {}
M.formatstring = function(hl_group, txt)
  return string.format('%%#%s#%s%%*', hl_group, txt)
end
M.modes = {
  ['n']     = 'NORMAL',
  ['no']    = 'O-PEN',
  ['nov']   = 'O-PEN',
  ['noV']   = 'O-PEN',
  ['no\22'] = 'O-PEN',
  ['niI']   = 'NORMAL',
  ['niR']   = 'NORMAL',
  ['niV']   = 'NORMAL',
  ['nt']    = 'NORMAL',
  ['v']     = 'VISUAL',
  ['vs']    = 'VISUAL',
  ['V']     = 'V-LINE',
  ['Vs']    = 'V-LINE',
  ['\22']   = 'V-BLK',
  ['\22s']  = 'V-BLK',
  ['s']     = 'SELECT',
  ['S']     = 'S-LINE',
  ['\19']   = 'S-BLK',
  ['i']     = 'INSERT',
  ['ic']    = 'INSERT',
  ['ix']    = 'INSERT',
  ['R']     = 'REPLACE',
  ['Rc']    = 'REPLACE',
  ['Rx']    = 'REPLACE',
  ['Rv']    = 'V-REPL',
  ['Rvc']   = 'V-REPL',
  ['Rvx']   = 'V-REPL',
  ['c']     = 'COMMAND',
  ['cv']    = 'EX',
  ['ce']    = 'EX',
  ['r']     = 'REPLACE',
  ['rm']    = 'MORE',
  ['r?']    = 'CONFIRM',
  ['!']     = 'SHELL',
  ['t']     = 'TERM',
}
M.mode_hls = {
  ['n'] = { fg = '#00ff00' },
  ['i'] = { fg = '#ff0000' },
  ['v'] = { fg = '#fff000' },
  ['t'] = { bg = '#000000', fg = '#ffffff' },
  ['V'] = { fg = "cyan" },
  ['\22'] = { fg = "cyan" },
  ['c'] = { fg = "orange" },
  ['s'] = { fg = "purple" },
  ['S'] = { fg = "purple" },
  ['\19'] = { fg = "purple" },
  ['R'] = { fg = "orange" },
  ['r'] = { fg = "orange" },
  ['!'] = { fg = "red" },
}
M.init = function()
  if M.initialise then
    M.augroup = vim.api.nvim_create_augroup("StatusLine", { clear = true })
    vim.api.nvim_set_hl(0, 'statusline_mode', { fg = '#00ff00' })
    vim.api.nvim_set_hl(0, 'statusline_git', { fg = '#ffff00' })
    --vim.api.nvim_set_hl(0, 'statusline', { fg = '#ffff00' })
    M.status()
    M.recorder()
    M.diagnostics()
    M.segments[#M.segments + 1] = '%='
    M.searchCount()
    M.git()
    --M.segments[#M.segments+1]  =  M.formatstring('statusline_git',  "%{get(b:,'gitsigns_status','')}")
    M.cursorMove()
    local term_prg = os.getenv("TERM_PROGRAM")
    if term_prg and term_prg == 'WezTerm' then
      M.sync = function()
        local stl = vim.api.nvim_eval_statusline(table.concat(M.segments), { highlights = true })
        M.send(vim.fn.json_encode(stl))
      end
    else
      M.sync = function()
        vim.opt.statusline = table.concat(M.segments)
      end
    end
    M.sync()
    M.initialise = false
  end
end
M.status = function()
  local segmentIdx = #M.segments + 1
  M.segments[segmentIdx] = M.formatstring('statusline_mode', "[" .. M.modes[vim.fn.mode(false)] .. "]")
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = M.augroup,
    pattern = "*",
    callback = function()
      local mode = vim.fn.mode(false)
      if M.mode_hls[mode] then
        vim.api.nvim_set_hl(0, 'statusline_mode', M.mode_hls[mode])
      end
      M.segments[segmentIdx] = M.formatstring('statusline_mode', "[" .. M.modes[mode] .. "] ")
      M.sync()
    end,
  })
end
M.git = function()
  local segmentIdx = #M.segments + 1
  M.segments[segmentIdx] = ''
  M.segments[segmentIdx + 1] = ''
  vim.api.nvim_create_autocmd('User', {
    pattern = 'GitSignsUpdate',
    group = M.augroup,
    callback = function(args)
      if args.data and vim.b[args.data.buffer] then
        local git_status_dict = vim.b[args.data.buffer].gitsigns_status_dict
        local added = (git_status_dict.added and git_status_dict.added ~= 0) and ("  " .. git_status_dict.added) or ""
        local changed = (git_status_dict.changed and git_status_dict.changed ~= 0) and ("  " .. git_status_dict.changed) or ""
        local removed = (git_status_dict.removed and git_status_dict.removed ~= 0) and ("  " .. git_status_dict.removed) or ""
        M.segments[segmentIdx] = (added .. changed .. removed) ~= "" and (added .. changed .. removed .. " | ") or ""
        M.segments[segmentIdx+1] = " " .. git_status_dict.head .. " "
        M.sync()
      end
    end
  })
end

M.recorder = function()
  local segmentIdx = #M.segments + 1
  M.segments[segmentIdx] = ''
  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    pattern = '*',
    group = M.augroup,
    callback = function(args)
      if args.event == 'RecordingEnter' then
        M.segments[segmentIdx] = '@' .. vim.fn.reg_recording() .. ' '
      else
        M.segments[segmentIdx] = ''
      end
      M.sync()
    end
  })
end

M.diagnostics = function()
  local segmentIdx = #M.segments + 1
  M.segments[segmentIdx] = ''
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = function(args)
      local diagnostics = args.data.diagnostics
    end,
  })
end

M.searchCount = function()
  local segmentIdx = #M.segments + 1
  M.segments[segmentIdx] = ''
  vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = '*',
    group = M.augroup,
    callback = function()
      print(vim.fn.getcmdtype() .. '   --- ')
      local st = ''
      if vim.fn.getcmdtype() == '/'
          or vim.fn.getcmdtype() == '?'
          or string.sub(vim.fn.getcmdline(), 1, 2) == 'g/'
          or string.sub(vim.fn.getcmdline(), 1, 3) == 'g!/'
          or string.sub(vim.fn.getcmdline(), 1, 2) == 'v/'
      then
        local search = vim.fn.searchcount()
        if search.total ~= 0 then
          st = '[' .. search.current .. '/' .. search.total .. '] '
        end
        print('   !!!!! ' .. st)
      end
      M.segments[segmentIdx] = st
      M.sync()
    end
  })
end

M.cursorMove = function()
  M.segments[#M.segments + 1] = '%P'
  M.segments[#M.segments + 1] = ' '
  M.segments[#M.segments + 1] = '[%l:%v]'
  vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    group = M.augroup,
    callback = function()
      M.sync()
    end,
  })
end
return M
