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

Plug 'altercation/vim-colors-solarized'

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
lua << EOF

util = require 'lspconfig/util'

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

EOF
