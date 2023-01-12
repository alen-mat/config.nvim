if exists(':AsyncRun')
  nnoremap <buffer><silent> <F9> :<C-U>AsyncRun python -u "%"<CR>
  nnoremap <buffer> <F10> :<C-U>AsyncRun -mode=term python %<CR>
endif

setlocal expandtab
setlocal smarttab
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4 

setlocal nowrap
setlocal sidescroll=5
setlocal sidescrolloff=2
setlocal colorcolumn=100

" {{{ Mappings
" CTRL K moves to the function definition above
" CTRL J moves to the function definition below
nmap <leader>k [pf
nmap <leader>j ]pf

nnoremap <buffer><silent> <space>pf <cmd>Pytest file<CR>
nnoremap <buffer><silent> <space>pc <cmd>Pytest function<CR>
nnoremap <buffer><silent> <space>pm <cmd>Pytest method<CR>
nnoremap <buffer><silent> <space>ps <cmd>Pytest session<CR>
" }}}
"
"
"augroup MyPythonAutos
"  au!
"  autocmd BufWritePost *.py :call PythonAuto()
"augroup END
