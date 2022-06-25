set tabstop=4
set shiftwidth=4
set softtabstop=4

set path=.,src/main/java/**,/Git/icf.social.common/common/**,/Git/icf.social.streambuilder/**,/usr/include,,
setlocal suffixesadd+=.kt
setlocal include=^#\s*import
setlocal includeexpr=substitute(v:fname,'\\.','/','g')

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql

setlocal foldmethod=expr
setlocal foldexpr=KotlinFolds(v:lnum)

normal zx

function! KotlinFolds(lnum)
  let thisline = getline(v:lnum)
  if thisline =~? '\v^\s*$'
    return '-1'
  endif

  if thisline =~ '^import.*$'
    return 1
  " else
  "   return IndentLevel(v:lnum)
  endif
endfunction

function! IndentLevel(lnum)
  return indent(v:lnum) / &shiftwidth
endfunction

let g:grep_path = "./src"
