vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

nmap("<leader><F5>", ":!zellij run -f -- mvn test<CR>", 'Maven test')

vim.keymap.set('<F5>', '<F5>',  ":!zellij run -f -- mvn clean install<CR>", { desc = 'Maven Build' })
