local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local _ = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'


    -- Telescope for file searching/greping
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Harpoon for file hopping
    use { 'ThePrimeagen/harpoon' }

    -- Treesitter for syntax highlighting
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    -- Themes
    use("scottmckendry/cyberdream.nvim", { opt = true })
    use("catppuccin/nvim", { opt = true })

    -- Unimpaired
    use('tpope/vim-Unimpaired')


    -- Surround
    use('tpope/vim-surround')


    -- Undo tree
    use('mbbill/undotree')

    -- Git support
    use('tpope/vim-fugitive')


    -- LSP config
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use 'nvimtools/none-ls-extras.nvim'

    -- null ls to add additional LSP functionality
    use {
        'nvimtools/none-ls.nvim',
        dependencies = {
            'nvimtools/none-ls-extras.nvim'
        }
    }

    -- Like make command but determines build system from file
    use {
        'neomake/neomake',
    }


    -- Autopairs
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- Tabbar
    use { 'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons' }

    -- bufferline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- todos
    use { 'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- Git signs
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }

    -- typescript tools
    use {
        "pmizio/typescript-tools.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    }

    -- commentary operator
    use { 'tpope/vim-commentary' }

    -- debugger
    use 'mfussenegger/nvim-dap'
    use 'leoluz/nvim-dap-go'
    use { 'rcarriga/nvim-dap-ui', requires = "nvim-neotest/nvim-nio" }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'nvim-telescope/telescope-dap.nvim'

    -- Hard time
    use 'takac/vim-hardtime'

    -- Extended omnisharp support
    use "Hoffs/omnisharp-extended-lsp.nvim"

    -- Startup time
    use 'dstein64/vim-startuptime'
end)
