" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
" runtime! archlinux.vim

set backup		" keep a backup file
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" set tab stops to 3 characters
set tabstop=2
" set indents to 3 characters
set sw=2
set softtabstop=2
set expandtab
set spell
set number
set relativenumber
set smartindent
set laststatus=2
set autoindent		" always set autoindenting on
" Scrolloff controls the minimum number of lines above and below the cursor
set scrolloff=5

" Setup the backup directory to be /tmp.  The double // will ensure that the
" backup file is unique to the path of the file being edited.
set backupdir=/tmp//,.,$XDG_DATA_HOME/nvim/backup//

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

let mapleader=","
map <Leader>/ <c-_><c-_>

nmap <leader>ev :vsplit $MYVIMRC<cr>

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Set where tag files can be found
set tags=.git/tags,tags

set statusline=%n:\ %<%-.50f%h%m%r%=%(%l,%c%V\ %=\ %P%)

" Automatically install vim-plug in the data directory for this machine
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.config/nvim/'
if empty(glob(data_dir . '/autoload/plug.vim'))
   silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let config_dir = has('nvim') ? stdpath('config') : '~/.config/nvim'
" The directory provide here is where the plugins will be cloned to.
call plug#begin(data_dir . '/plugins')

source ~/.config/nvim/plugins/git.vim
source ~/.config/nvim/plugins/syntastic.vim
source ~/.config/nvim/plugins/tcomment.vim
source ~/.config/nvim/plugins/lsp.vim
source ~/.config/nvim/plugins/telescope.vim

Plug 'altercation/vim-colors-solarized'
Plug 'udalov/kotlin-vim'
Plug 'tpope/vim-projectionist'
Plug 'mbbill/undotree'

call plug#end()

if has('gui_running')
   set background=dark
else
   set background=dark
   if ($TERM == "xterm-256color")
     let g:solarized_termcolors=256
   endif
endif

colorscheme solarized
 
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

augroup END

map <Leader>e :lua vim.diagnostic.open_float()<CR>
" abbreviation for date time
iab <expr> <date> strftime("%m/%d/%y %H:%M")

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 500})
augroup END

lua << EOF
util = require 'lspconfig/util'

local opts = { noremap=true, silent=true }
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

require'lspconfig'.sumneko_lua.setup {
  cmd = require'lspcontainers'.command('sumneko_lua'),
  }

require'lspconfig'.bashls.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  cmd = require'lspcontainers'.command('bashls'),
  root_dir = util.root_pattern(".git", vim.fn.getcwd())
}

require('telescope').setup { 
  defaults = { 
    file_ignore_patterns = {"%.class"}
  }
}

require'lspconfig'.tsserver.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  on_attach = on_attach,
  cmd = require'lspcontainers'.command(
    'tsserver',
    {
        cmd_builder = function (runtime, workdir, image, network)
          local node_modules_volume = string.gsub(vim.fn.system("docker volume ls | grep 'node_modules' | awk '{print $2}'"), '\n', '')

          local cmd = {
            runtime,
            "container",
            "run",
            "--interactive",
            "--rm",
            "--network="..network,
            "--workdir="..workdir
            }

          if node_modules_volume ~= '' then
            table.insert(cmd, "--volume="..node_modules_volume..":"..workdir.."/node_modules:ro")
          end

          table.insert(cmd, "--volume="..workdir..":"..workdir..":ro")
          table.insert(cmd, image)

          return cmd
        end,
    }
  ),
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),

  require'lspconfig'.kotlin_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = require'lspcontainers'.command('tsserver', {
      image = "kotlin-language-server:latest",
      cmd = function (runtime, volume, image)
      return {
        runtime,
        "container",
        "run",
        "--name",
        "kotlin_language_server",
        "--interactive",
        "--rm",
        "--volume",
        volume .. ":" .. volume .. ":ro",
        image
        }
    end,
    }),
  }
}
EOF
