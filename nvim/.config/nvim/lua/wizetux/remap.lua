vim.g.mapleader = ","

-- Edit init.lua
vim.keymap.set("n", "<leader>ev", function()
	vim.cmd('vsplit $MYVIMRC')
end)

vim.keymap.set("n", "<leader>u", function()
	vim.cmd('UndotreeToggle')
end)

vim.keymap.set("n", "<leader>e", function () 
  vim.diagnostic.open_float()
end)

vim.cmd([[
	map <Leader>/ gcc
	]])

-- Insert date header (### YYYY-MM-DD)
vim.api.nvim_create_user_command('InsertDateHeader', function()
	local date = os.date("%Y-%m-%d")
	vim.api.nvim_put({ "### " .. date }, "l", true, true)
end, {})
