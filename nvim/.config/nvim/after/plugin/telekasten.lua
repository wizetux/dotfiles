local home = vim.fn.expand("~/zettelkasten") 
require('telekasten').setup({
  home = home, -- Put the name of your notes directory here
  dailies = home .. "/dailies",
  weeklies = home .. "/weeklies",
  template_new_note = home .. "/templates/new_note.md",
  template_new_daily = home .. "/templates/new_daily_note.md",
  new_note_filename = "uuid-title", -- prefix title by uuid
})

-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

-- Most used functions
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")

