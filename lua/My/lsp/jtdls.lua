local home = vim.fn.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local mason_registry = require("mason-registry")

local jdtls_pkg = mason_registry.get_package("jdtls")
local jdtls_pkg_path = jdtls_pkg:get_install_path()
local jdtls_launcher_path = vim.fn.glob(
  jdtls_pkg_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'
)

local java_dap_pkg = mason_registry.get_package("java-debug-adapter")
local java_dap_pkg_path = java_dap_pkg:get_install_path()
local java_dap_launcher_path = vim.fn.glob(
  java_dap_pkg_path .. '/extensions/server/com.microsoft.java.debug.plugin-*.jar'
)

local java_test_package = mason_registry.get_package('java-test'):get_install_path()
local java_test_path = vim.split(
  vim.fn.glob(java_test_package .. '/extension/server/*.jar'),
  '\n'
)

local bundles= {java_dap_launcher_path}
vim.list_extend(bundles, java_test_path)


local workspace_dir = jdtls_pkg_path .. '/workspace/' .. project_name
local java_bin = "/usr/lib/jvm/java-17-openjdk/bin/java"


local config = {
  cmd = {
    -- java17 or newer
    java_bin,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    jdtls_launcher_path,
    '-configuration', home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
    '-data', workspace_dir,
  },

  root_dir = function(fname)
    return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git", "lsp.This")(fname) or
        vim.fn.getcwd()
  end,

  filetypes = { "java" },

  settings = {
    ['java.format.settings.url'] = home .. "/.config/nvim/language-servers/java-google-formatter.xml",
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
        enabled = true, --Don"t automatically show implementations
      },
      inlayHints = {
        parameterNames = { enabled = "all" }
      },
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true, --Don"t automatically show references
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
          --          {
          --            name = "JavaSE-20",
          --            path = "/usr/lib/jvm/java-20-openjdk",
          --          },
        }
      },
    },
  },

  init_options = {
    bundles = bundles,
  },
}

local jdtls = require("jdtls")
config.init_options.extendedClientCapabilities = jdtls.extendedClientCapabilities
config.init_options.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local function on_attach(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<F5>", ":!zellij run -f -- mvn clean install<CR>", 'Maven build')

  nmap('<A-o>', jdtls.organize_imports, 'Organize Imports')


  nmap('<leader>crv ', jdtls.extract_variable, 'Extract Variable')

  -- vnoremap('crv ', jdtls.extract_variable(true), 'Extract Variable')
  nmap('<leader>crc ', jdtls.extract_constant, 'Extract constants')
  --vnoremap('crc ', jdtls.extract_constant(true), 'Extract constants')
  --vnoremap('crm ', jdtls.extract_method(true), 'Extract method')
  nmap('<leader>df', jdtls.test_class, 'Test class')
  nmap('<leader>dn', jdtls.test_nearest_method, 'Test method')
end


return { settings = config, on_attach = on_attach }

-- vim: ts=2 sts=2 sw=2 et
