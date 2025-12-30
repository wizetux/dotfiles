require('telescope').setup({
  defaults = { 
    file_ignore_patterns = {"%.class"}
  }
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gw', builtin.grep_string, {})
vim.keymap.set('v', '<leader>gw', function()
  local saved_reg = vim.fn.getreg('"')
  vim.cmd([[noautocmd sil norm y]])
  local selection = vim.fn.getreg('"')
  vim.fn.setreg('"', saved_reg)
  require('telescope.builtin').grep_string({ search = selection })
end, { desc = 'Grep visual selection' })
