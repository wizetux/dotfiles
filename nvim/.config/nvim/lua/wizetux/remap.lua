vim.g.mapleader = ","

-- Edit init.lua
vim.keymap.set("n", "<leader>ev", function()
	vim.cmd('vsplit $MYVIMRC')
end)

vim.keymap.set("n", "<leader>u", function()
	vim.cmd('UndotreeToggle')
end)

vim.cmd([[
	map <Leader>/ <c-_><c-_>
	]])
