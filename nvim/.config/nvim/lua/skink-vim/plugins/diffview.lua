require('diffview').setup {}

vim.keymap.set('n', '<leader>gd', function() vim.cmd('DiffviewOpen main') end,
    { desc = 'Diffview: Open diff vs main' })
vim.keymap.set('n', '<leader>gD', vim.cmd.DiffviewClose, { desc = 'Diffview: Close' })
