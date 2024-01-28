return {
  'nvim-orgmode/orgmode',
  dependencies = {
    'nvim-treesitter/nvim-treesitter'
  },
  ft = 'org',
  config = function()
    require('orgmode').setup_ts_grammar()
    require('orgmode').setup {
      org_agenda_files = { '~/Workspace/org/*', '~/my-orgs/**/*' },
      org_default_notes_file = '~/Workspace/org/refile.org',
      org_todo_keywords = { 'TODO(t)', 'NEXT', '|', 'DONE' },
      mappings = {
        global = {
          org_agenda = { '<Leader>oa' },
          org_capture = { '<Leader>oc' }
        }
      }
    }
  end
}
