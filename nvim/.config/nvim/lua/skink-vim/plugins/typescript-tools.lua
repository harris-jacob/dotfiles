require("typescript-tools").setup {
    on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }

        -- Override gd: try source definition (skips .d.ts), fall back to vim.lsp.buf.definition
        -- Note: telescope lsp_definitions is NOT used as fallback because file_ignore_patterns
        -- filters node_modules/, which drops external library .d.ts results.
        vim.keymap.set('n', 'gd', function()
            local params = vim.lsp.util.make_position_params(0, 'utf-8')
            vim.lsp.buf_request(0, '_typescript.goToSourceDefinition', params,
                function(err, result)
                    if err or not result or #result == 0 then
                        vim.lsp.buf.definition()
                    else
                        vim.lsp.util.jump_to_location(result[1], 'utf-8')
                    end
                end
            )
        end, vim.tbl_extend('force', opts, { desc = 'TSTools: Go to source definition (fallback to lsp)' }))

        -- TS-specific actions
        vim.keymap.set('n', '<leader>to', '<cmd>TSToolsOrganizeImports<CR>',
            vim.tbl_extend('force', opts, { desc = 'TSTools: Organize imports' }))
        vim.keymap.set('n', '<leader>ta', '<cmd>TSToolsAddMissingImports<CR>',
            vim.tbl_extend('force', opts, { desc = 'TSTools: Add missing imports' }))
        vim.keymap.set('n', '<leader>tr', '<cmd>TSToolsRenameFile<CR>',
            vim.tbl_extend('force', opts, { desc = 'TSTools: Rename file' }))
        vim.keymap.set('n', '<leader>tu', '<cmd>TSToolsRemoveUnusedImports<CR>',
            vim.tbl_extend('force', opts, { desc = 'TSTools: Remove unused imports' }))
    end,
}
