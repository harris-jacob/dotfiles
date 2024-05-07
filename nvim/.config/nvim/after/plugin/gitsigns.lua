require('gitsigns').setup {
    current_line_blame = true,
    signcolumn = true,
    current_line_blame_opts = {
        delay = 1000,
        virt_text_pos = 'eol',
    }
}

vim.cmd [[
hi clear GitSignsCurrentLineBlame
highlight link GitSignsCurrentLineBlame Comment
]]
