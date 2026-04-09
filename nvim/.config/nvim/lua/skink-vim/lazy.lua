-- Must be set before lazy.setup() so <leader> keymaps register correctly
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Telescope for file searching/grepping
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')

            -- File pickers
            vim.keymap.set('n', '<leader>ff',  builtin.find_files,  { desc = 'Telescope: Find Files' })
            vim.keymap.set('n', '<leader>fs',  builtin.live_grep,   { desc = 'Telescope: Live Grep' })
            vim.keymap.set('n', '<leader>fg',  builtin.git_files,   { desc = 'Telescope: Git Files' })
            vim.keymap.set('n', '<leader>fb',  builtin.buffers,     { desc = 'Telescope: Buffers' })
            vim.keymap.set('n', '<leader>fh',  builtin.help_tags,   { desc = 'Telescope: Show Help Tags' })
            vim.keymap.set('n', '<leader>fk',  builtin.keymaps,     { desc = 'Telescope: Show Keymaps' })
            vim.keymap.set('n', '<leader>fll', builtin.loclist,     { desc = 'Telescope: Show Location List for buffer' })

            -- LSP pickers
            vim.keymap.set('n', '<leader>cd', builtin.diagnostics,  { desc = 'Telescope: Show Diagnostics' })

            -- Git pickers
            vim.keymap.set('n', '<leader>gc',  builtin.git_commits, { desc = 'Telescope: Show Git Commits' })
            vim.keymap.set('n', '<leader>gbc', builtin.git_commits, { desc = 'Telescope: Show Git Branch Commits' })
            vim.keymap.set('n', '<leader>gs',  builtin.git_commits, { desc = 'Telescope: Show Git Status' })

            require('telescope').setup({
                defaults = {
                    prompt_prefix = '🔍 ',
                    file_ignore_patterns = { '.git/', 'node_modules/', '.cache/' },
                    dynamic_preview_title = true,
                    vimgrep_arguments = {
                        'rg', '--ignore', '--hidden', '--color=never',
                        '--no-heading', '--with-filename', '--line-number',
                        '--column', '--smart-case', '--trim',
                    },
                },
            })
        end,
    },

    -- Treesitter for syntax highlighting (branch = 'master' required for nvim < 0.11)
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        branch = 'master',
        lazy = false,
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "c", "lua", "rust", "typescript", "go", "javascript", "elixir" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "make" },
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    },

    -- Themes (lazy-loaded, loaded on demand by colorscheme.lua)
    { 'scottmckendry/cyberdream.nvim', lazy = true },
    { 'catppuccin/nvim',               lazy = true },

    -- Unimpaired
    { 'tpope/vim-Unimpaired' },

    -- Surround
    { 'tpope/vim-surround' },

    -- Undo tree
    {
        'mbbill/undotree',
        config = function() require('skink-vim.plugins.undotree') end,
    },

    -- Git support
    {
        'tpope/vim-fugitive',
        config = function() require('skink-vim.plugins.fugitive') end,
    },

    -- LSP config
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            -- Snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
        config = function() require('skink-vim.plugins.lsp') end,
    },

    -- none-ls for prettier formatting
    {
        'nvimtools/none-ls.nvim',
        config = function() require('skink-vim.plugins.none-ls') end,
    },

    -- Autopairs
    {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {} end,
    },

    -- Tabbar
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function() require('skink-vim.plugins.bufferline') end,
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function() require('skink-vim.plugins.lualine') end,
    },

    -- Todos
    {
        'folke/todo-comments.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('skink-vim.plugins.todo-comments') end,
    },

    -- Git signs
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('skink-vim.plugins.gitsigns') end,
    },

    -- TypeScript tools
    {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        config = function() require('skink-vim.plugins.typescript-tools') end,
    },

    -- Debugger
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'leoluz/nvim-dap-go',
            { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
            'theHamsta/nvim-dap-virtual-text',
            'nvim-telescope/telescope-dap.nvim',
        },
        config = function() require('skink-vim.plugins.dap') end,
    },

    -- Hard time (forces better vim habits)
    { 'takac/vim-hardtime' },

    -- Extended omnisharp support
    { 'Hoffs/omnisharp-extended-lsp.nvim' },

    -- Startup time profiler
    { 'dstein64/vim-startuptime' },
})

-- Colorscheme must run after lazy.setup() so that lazy.load() works for themes
require('skink-vim.plugins.colorscheme')
