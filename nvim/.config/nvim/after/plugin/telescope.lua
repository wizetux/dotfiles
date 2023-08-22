require('telescope').setup({
  defaults = { 
    file_ignore_patterns = {"%.class"}
  }
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('v', '<leader>gs', function() 
	builtin.grep_string();
end)
