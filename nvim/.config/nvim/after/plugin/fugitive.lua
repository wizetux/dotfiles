vim.cmd([[
	" Find commit merge conflicts
	match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
]])
