nnoremap <leader>* :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>* :<c-u>call <SID>GrepOperator(visualmode())<cr>
let g:grep_path = "./src"

function! s:GrepOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    execute "normal! `<v`>y"
  elseif a:type ==# 'char'
    normal! `[y`]
  else
    return
  endif

  silent execute "grep! -R " . shellescape(@@) . " " . g:grep_path
  copen

  let @@ = saved_unnamed_register
endfunction
