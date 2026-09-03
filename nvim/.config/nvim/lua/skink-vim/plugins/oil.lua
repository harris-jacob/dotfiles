require('oil').setup {
    -- Use full window (default_file_explorer replaces netrw)
    default_file_explorer = true,
    view_options = {
        show_hidden = true,
    },
}

vim.keymap.set('n', '<leader>pv', '<cmd>Oil<CR>', { desc = 'Oil: Open file explorer' })
