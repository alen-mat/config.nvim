return {
  manual_install = true,
  cmd = { "dune", "exec", "ocamllsp" },
  settings = {
    codelens = { enable = true },
    inlayHints = { enable = true },
    syntaxDocumentation = { enable = true },
  },
  server_capabilities = {
    semanticTokensProvider = false,
  },
}
-- vim: ts=2 sts=2 sw=2 et
