local dap = require('dap')
local java_bin = "/usr/lib/jvm/java-17-openjdk/bin/java"
dap.configurations.java = {
  {
    -- You need to extend the classPath to list your dependencies.
    -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
    --classPaths = {},

    -- If using multi-module projects, remove otherwise.
    --projectName = "yourProjectName",

    javaExec = java_bin,
    mainClass = "your.package.name.MainClassName",

    -- If using the JDK9+ module system, this needs to be extended
    -- `nvim-jdtls` would automatically populate this property
    --modulePaths = {},
    name = "Launch Main",
    request = "launch",
    type = "java"
  },
}
