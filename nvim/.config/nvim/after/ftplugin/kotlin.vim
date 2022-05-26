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

lua << EOF
 util = require 'lspconfig/util'
 
 -- Use an on_attach function to only map the following keys
 -- after the language server attaches to the current buffer
 local on_attach = function(client, bufnr)
   -- Enable completion triggered by <c-x><c-o>
   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
 
   -- Mappings.
   -- See `:help vim.lsp.*` for documentation on any of the below functions
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
 end
 
-- require'lspconfig'.kotlin_language_server.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd = require'lspcontainers'.command('tsserver', {
--     image = "kotlin-language-server:latest",
--     cmd = function (runtime, volume, image)
--     return {
--       runtime,
--       "container",
--       "run",
--       "--name",
--       "kotlin_language_server",
--       "--interactive",
--       "--rm",
--       "--volume",
--       volume .. ":" .. volume .. ":ro",
--       image
--       }
--   end,
--   }),
-- }
EOF
