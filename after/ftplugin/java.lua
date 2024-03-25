vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

vim.keymap.set('n',"<leader><F5>", ":!zellij run -f -- mvn test<CR>", { desc ='Maven test'})

vim.keymap.set('n','<F5>',  ":!zellij run -f -- mvn clean install<CR>", { desc = 'Maven Build' })
