" set tab stops to 3 characters
set tabstop=4
" set indents to 3 characters
set sw=4
set softtabstop=4

augroup PHP_CMDS | au!
  autocmd BufNewFile *Controller.php 0r ~/.config/nvim/templates/php/controller.tpl
augroup END

" if expand("%:p:h") =~ 'naiad' ||  expand("%:p:h") =~ 'icf.'
if expand("%:p:h") =~ 'naiad'
    let b:syntastic_checkers = ['php']
else 
    let b:syntastic_checkers = ['php', 'phpcs']
endif

let g:syntastic_php_phpcs_args = "--runtime-set installed_paths ~/.config/linters/php/phpcs --standard=modifiedPSR2 -p -s"

set path=.,src/**,test/**,vendor/**,,

nnoremap <c-j> /<+.\{-1,}+><cr>c/+>/e<cr>
inoremap <c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr>
