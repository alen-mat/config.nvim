return {
  settings = {
    ['java.format.settings.url'] = vim.fn.getenv("HOME") .. "/.config/nvim/language-servers/java-google-formatter.xml",
    ['java.format.settings.profile'] = "GoogleStyle",
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
        }
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
