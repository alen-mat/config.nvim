local has_lsp_attached = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(bufnr)
  return next(clients) ~= nil
end

return {
  'glepnir/galaxyline.nvim',
  branch = 'main',
  config = function()
    vim.o.showmode=false
    local galaxyline = require('galaxyline')
    local colors = require('galaxyline.colors')
    local fileinfo = require('galaxyline.provider_fileinfo')
    local diagnostic = require('galaxyline.provider_diagnostic')
    local condition = require('galaxyline.condition')
    local vcs = require('galaxyline.provider_vcs')

    local modes = {
      n       = { text = "NORMAL", fg = colors.bg, bg = colors.yellow, },
      i       = { text = "INSERT", bg = colors.green, },
      v       = { text = "VISUAL", bg = colors.blue, },
      V       = { text = "VISUAL-LINE", bg = colors.blue, },
      ['']   = { text = "VISUAL-BLOCK", bg = colors.blue, },
      S       = { text = "SELECT-LINE", bg = colors.red, },
      ['']   = { text = "SELECT-BLOCK", bg = colors.red, },
      c       = { text = "COMMAND", fg = colors.bg, bg = colors.blue, },
      R       = { text = "REPLACE", bg = colors.red, },
      r       = { text = "PRESS ENTER", fg = colors.bg, bg = colors.green, },
      t       = { text = "TERMINAL", fg = colors.bg, bg = colors.red, },
      default = { text = nil, fg = colors.bg, bg = colors.red, },
    }
    for m, _ in pairs(modes) do
      modes[m] = vim.tbl_extend("keep", modes[m], { fg = colors.fg, bg = colors.bg })
    end
    local vimode = modes.n
    table.insert(galaxyline.section.left, {
      Vim = {
        provider = function()
          vimode = modes[vim.fn.mode()] or modes.default
          return '  ' .. vimode.text
        end,
        separator = '  ',
        separator_highlight = { 'NONE', colors.bg },
        highlight = { colors.red, colors.bg, 'bold' },
      }
    })
--    table.insert(galaxyline.section.left, {
--      VimSeparator = {
--        provider = function()
--          vimode = modes[vim.fn.mode()] or modes.default
--          vim.api.nvim_command('hi GalaxyVimSeparator guifg=' .. colors.bg .. ' guibg=' .. vimode.bg)
--          return '>'
--        end,
--      }
--    })

    table.insert(galaxyline.section.left, {
      FileSize = {
        provider = 'FileSize',
        condition = condition.buffer_not_empty,
        icon = '   ',
        highlight = { colors.green, colors.purple },
        separator = ' ',
        separator_highlight = { colors.purple, colors.darkblue },
      },
    })
    table.insert(galaxyline.section.left, {
      LspServerName = {
        condition = function()
          return condition.buffer_not_empty() and has_lsp_attached()
        end,
        provider = require('galaxyline.provider_lsp').get_lsp_client,
        icon = ' ',
        separator = ' ',
        highlight = { colors.violet, colors.grayblue },
      }
    })

    table.insert(galaxyline.section.left, {
      DiagnosticErrors = {
        condition = function()
          return condition.buffer_not_empty() and has_lsp_attached()
        end,
        provider = diagnostic.get_diagnostic_error,
        icon = ' ',
        separator = ' ',
        highlight = { colors.red, colors.none, },
      }
    })
    table.insert(galaxyline.section.left, {
      DiagnosticWarnings = {
        condition = function()
          return condition.buffer_not_empty() and has_lsp_attached()
        end,
        provider = diagnostic.get_diagnostic_warn,
        icon = ' ',
        separator = ' ',
        highlight = { colors.orange, colors.none, },
      }
    })
    table.insert(galaxyline.section.left, {
      DiagnosticInfo = {
        condition = function()
          return condition.buffer_not_empty() and has_lsp_attached()
        end,
        provider = diagnostic.get_diagnostic_info,
        icon = ' ',
        separator = ' ',
        highlight = { colors.violet, colors.none, },
      }
    })
    table.insert(galaxyline.section.left, {
      DiagnosticHints = {
        condition = function()
          return condition.buffer_not_empty() and has_lsp_attached()
        end,
        provider = diagnostic.get_diagnostic_hint,
        icon = 'ﯧ ',
        highlight = { colors.gray, colors.none, },
      }
    })

    table.insert(galaxyline.section.mid, {
      FileIcon = {
        provider = 'FileIcon',
        condition = condition.buffer_not_empty,
        separator = ' ',
        highlight = { fileinfo.get_file_icon_color, colors.grayblue },
      }
    })
    table.insert(galaxyline.section.mid, {
      FileName = {
        condition = condition.buffer_not_empty,
        provider = function()
          return vim.fn.expand('%:.') .. ' '
        end,
        separator = ' ',
        highlight = { colors.fg, colors.grayblue, },
      }
    })

    table.insert(galaxyline.section.right, {
      GitBranch = {
        condition = condition.check_git_workspace,
        provider = vcs.get_git_branch,
        icon = '  ',
        highlight = { colors.orange, colors.bg },
        separator = '[',
        separator_highlight = { colors.bg, colors.none },
      }
    })

    table.insert(galaxyline.section.right, {
      GitDiffs = {
        condition = condition.check_git_workspace,
        provider = vcs.diff_modified,
        icon = '~',
        separator = ' ',
        highlight = { colors.blue, colors.none },
      }
    })
    table.insert(galaxyline.section.right, {
      GitAdds = {
        condition = condition.check_git_workspace,
        provider = vcs.diff_add,
        icon = '+',
        separator = ' ',
        highlight = { colors.green, colors.none },
      }
    })
    table.insert(galaxyline.section.right, {
      GitRems = {
        condition = condition.check_git_workspace,
        provider = vcs.diff_remove,
        icon = '-',
        separator = ' ',
        highlight = { colors.red, colors.none },
      }
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
