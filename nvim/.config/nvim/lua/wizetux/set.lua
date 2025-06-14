vim.opt.backup = true
-- keep 50 lines of command line history
vim.opt.history = 50
-- show the cursor position all the time
vim.opt.ruler = true
-- display incomplete commands
vim.opt.showcmd = true
-- do incremental searching
vim.opt.incsearch = true
vim.opt.tabstop = 2
vim.opt.sw = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.spell = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.laststatus = 2
-- always set autoindenting on
vim.opt.autoindent = true
-- Scrolloff controls the minimum number of lines above and below the cursor
vim.opt.scrolloff = 5

-- Setup the backup directory to be /tmp.  The double // will ensure that the
-- backup file is unique to the path of the file being edited.
vim.opt.backupdir = "/tmp//,.,$XDG_DATA_HOME/nvim/backup//"

-- Set where tag files can be found
vim.opt.tags = ".git/tags,tags"

vim.api.nvim_set_hl(0, 'tkLink', { ctermfg = "Blue", cterm = { bold = true, underline = true }, fg = "blue", bold = true, underline = true })
vim.api.nvim_set_hl(0, 'tkBrackets', { ctermfg = "grey", fg = "grey"})

-- Use OS clipboard for copy
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

vim.cmd([[
  set statusline=%n:\ %<%-.50f%h%m%r%=%(%l,%c%V\ %=\ %P%)
]])
