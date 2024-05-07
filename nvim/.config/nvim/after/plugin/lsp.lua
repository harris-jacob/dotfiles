local lsp = require('lsp-zero')
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local telescope = require('telescope.builtin')
local utils = require('skink-vim.utils')


lsp.preset('recommended')


-- Custom handler overrides for specific servers
local function lua_handler()
    require('lspconfig').lua_ls.setup({
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    })
end

local function omnisharp_handler()
    require('lspconfig').omnisharp.setup({
        settings = {
            omnisharp = {
                useModernNet = true,
                enableDecompilationSupport = true, -- Enable decompilation support
                enableMsBuildLoadProjectsOnDemand = false,
                enableRoslynAnalyzers = true
            }
        }
    })
end

require('mason').setup({})
require('mason-lspconfig').setup({
    -- servers that will be installed automatically by mason on first startup
    ensure_installed = {
        'tsserver',
        'eslint',
        'lua_ls',
        'rust_analyzer',
        'gopls',
        'elixirls',
        'omnisharp'
    },

    -- unless overridden, the default handler will be used
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        lua_ls = lua_handler,
        omnisharp = omnisharp_handler,
    },
})

-- Setup for servers that are not installed by mason
require('lspconfig').gleam.setup {}

-- Server specific keybindings, will override default keybindings
local custom_keymaps = {
    omnisharp = {
        ['gd'] = require('omnisharp_extended').telescope_lsp_definition,
        ['gi'] = require('omnisharp_extended').telescope_lsp_implementation,
        ['gtd'] = require('omnisharp_extended').telescope_lsp_type_definition,
        ['gr'] = require('omnisharp_extended').telescope_lsp_references
    }
}

-- Overwrite lsp-zero keymaps
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = true }

    -- LSP Navigation/Search
    vim.keymap.set('n', 'gd', telescope.lsp_definitions, utils.with_desc(opts, 'Telescope: Show Definitions'))
    vim.keymap.set('n', 'gi', telescope.lsp_implementations, utils.with_desc(opts, 'Telescope: Show LSP Implementations'))
    vim.keymap.set('n', 'gtd', telescope.lsp_type_definitions, utils.with_desc(opts, 'Telescope: Show Type Definitions'))
    vim.keymap.set('n', 'gr', telescope.lsp_references, utils.with_desc(opts, 'Telescope: Show References'))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, utils.with_desc(opts, "LSP: View hover info"))
    vim.keymap.set("n", "<leader>fws", vim.lsp.buf.workspace_symbol, utils.with_desc(opts, "LSP: Find workspace symbol"))

    -- Diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, utils.with_desc(opts, "LSP: Go to next diagnostic"))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts, utils.with_desc(opts, "LSP: Go to previous diagnostic"))

    -- Code actions
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, utils.with_desc(opts, "LSP: Code actions"))
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts, utils.with_desc(opts, "LSP: Format buffer"))
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, opts, utils.with_desc(opts, "LSP: Rename symbol"))


    local keybindings = custom_keymaps[client.name]
    if keybindings then
        for key, action in pairs(keybindings) do
            vim.keymap.set('n', key, action, opts)
        end
    end
end)


-- Overwrite lsp zero completion keymaps
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    }
})

vim.diagnostic.config({
    virtual_text = true,
})
