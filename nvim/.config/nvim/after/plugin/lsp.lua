local lsp = require('lsp-zero')
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()


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
        handlers = {
            ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
            ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
            ["textDocument/references"] = require('omnisharp_extended').references_handler,
            ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
        },
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

-- Overwrite lsp-zero keymaps
lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) Replaced with telescope
    -- vim.keymap.set("n", "gi", vim.lsp.buf.implementations, opts) Replaced with telescope
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, opts)
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
