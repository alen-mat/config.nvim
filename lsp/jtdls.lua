local config = {
  filetypes = { "java" },
  root_markers = { "gradle.properties" },
  cmd = { 'jdtls' },
  settings = {
    -- ['java.format.settings.url'] = vim.fn.getenv("HOME") .. "/.config/nvim/language-servers/java-google-formatter.xml",
    -- ['java.format.settings.profile'] = "GoogleStyle",
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        },
        importOrder = {
          "#",
          "java",
          "javax",
          "org",
          "com"
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      eclipse = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      inlayHints = {
        parameterNames = { enabled = "all" }
      },
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      saveActions = {
        organizeImports = true,
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        useBlocks = true,
      },
      flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
        server_side_fuzzy_completion = true
      },
      configuration = {
        updateBuildConfiguration = "automatic",
        runtimes = {
          {
            name = "JavaSE-11",
            path = '/usr/lib/jvm/java-11-openjdk',
          },
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk",
          },
          {
            name = "JavaSE-18",
            path = "/usr/lib/jvm/java-18-openjdk",
          },
          {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/java-21-openjdk",
            default = true,
          },
          compile = {
            nullAnalysis = {
              mode = "automatic",
            },
          },
          annotation = {
            processing = {
              enabled = true,
            },
          },
        }
      },
    },
  },
  init_options = {}
}

-- load all agents in here ..
config.init_options.vmArgs = ''
local grade_cache_dir_base = vim.fn.expand("~/.gradle/caches/modules-2/files-2.1/")

local jvm_agent_jars = {
  { name = "lombok", sub_path = "org.projectlombok/lombok", version = '1.18.30' }
}
for _, jar in ipairs(jvm_agent_jars) do
  local jars = vim.fs.find(function(name)
    return name == jar.name..'-'..jar.version..'.jar'
  end, {
    path = grade_cache_dir_base..jar.sub_path,
    type = "file",
    limit = math.huge,
  })
  config.init_options.vmArgs = config.init_options.vmArgs .. '-javaagent:'..jars[1]
end

return config
-- vim: ts=2 sts=2 sw=2 et
