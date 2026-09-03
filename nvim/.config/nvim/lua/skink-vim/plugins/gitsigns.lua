require('gitsigns').setup {
    current_line_blame = true,
    signcolumn = true,
    current_line_blame_opts = {
        delay = 1000,
        virt_text_pos = 'eol',
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr }

        -- Stage / reset
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk,       vim.tbl_extend('force', opts, { desc = 'Gitsigns: Stage hunk' }))
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk,       vim.tbl_extend('force', opts, { desc = 'Gitsigns: Reset hunk' }))
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk,  vim.tbl_extend('force', opts, { desc = 'Gitsigns: Undo stage hunk' }))
        vim.keymap.set('n', '<leader>hS', gs.stage_buffer,     vim.tbl_extend('force', opts, { desc = 'Gitsigns: Stage buffer' }))
        vim.keymap.set('n', '<leader>hR', gs.reset_buffer,     vim.tbl_extend('force', opts, { desc = 'Gitsigns: Reset buffer' }))

        -- Stage/reset partial selection in visual mode
        vim.keymap.set('v', '<leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, vim.tbl_extend('force', opts, { desc = 'Gitsigns: Stage selected hunk' }))
        vim.keymap.set('v', '<leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, vim.tbl_extend('force', opts, { desc = 'Gitsigns: Reset selected hunk' }))

        -- Preview / blame / diff
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk,                                  vim.tbl_extend('force', opts, { desc = 'Gitsigns: Preview hunk' }))
        vim.keymap.set('n', '<leader>hb', function() gs.blame_line({ full = true }) end,    vim.tbl_extend('force', opts, { desc = 'Gitsigns: Blame line (full)' }))
        vim.keymap.set('n', '<leader>hd', gs.diffthis,                                      vim.tbl_extend('force', opts, { desc = 'Gitsigns: Diff this file' }))

        -- Navigate hunks
        vim.keymap.set('n', ']h', gs.next_hunk, vim.tbl_extend('force', opts, { desc = 'Gitsigns: Next hunk' }))
        vim.keymap.set('n', '[h', gs.prev_hunk, vim.tbl_extend('force', opts, { desc = 'Gitsigns: Previous hunk' }))
    end,
}

vim.cmd [[
hi clear GitSignsCurrentLineBlame
highlight link GitSignsCurrentLineBlame Comment
]]
