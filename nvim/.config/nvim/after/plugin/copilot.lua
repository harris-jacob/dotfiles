vim.api.nvim_set_keymap('i', '<C-j>', 'copilot#Accept("<CR>")', {silent = true, expr = true, desc = "Copilot accept suggestion" })
-- turn copilot off for startup
vim.api.nvim_set_var('copilot#enabled', 0)
