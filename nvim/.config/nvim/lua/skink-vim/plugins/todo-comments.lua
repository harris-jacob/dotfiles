require("todo-comments").setup {}

vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<CR>',                          { desc = 'Todo: Find all todos' })
vim.keymap.set('n', '<leader>fT', '<cmd>TodoTelescope keywords=TODO,FIXME<CR>',      { desc = 'Todo: Find TODO/FIXME' })
