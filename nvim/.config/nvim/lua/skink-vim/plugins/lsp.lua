local telescope = require('telescope.builtin')
local utils = require('skink-vim.utils')

-- Mason: adds installed binaries (~/.local/share/nvim/mason/bin/) to PATH
require('mason').setup()

-- Auto-install servers via mason registry on first launch
local registry = require('mason-registry')
local servers_to_install = {
    'eslint-lsp',
    'lua-language-server',
    'rust-analyzer',
    'gopls',
    'elixir-ls',
    'omnisharp',
}
registry.refresh(function()
    for _, name in ipairs(servers_to_install) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then
            pkg:install()
        end
    end
end)

-- Server-specific config overrides (merged before vim.lsp.enable)
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

vim.lsp.config('omnisharp', {
    settings = {
        omnisharp = {
            useModernNet = true,
            enableDecompilationSupport = true,
            enableMsBuildLoadProjectsOnDemand = false,
            enableRoslynAnalyzers = true,
        }
    }
})

-- Enable servers (registers FileType autocmd; server starts when matching file opens)
vim.lsp.enable({ 'eslint', 'lua_ls', 'rust_analyzer', 'gopls', 'elixirls', 'omnisharp' })

-- Keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local opts = { buffer = ev.buf, remap = true }

        -- LSP Navigation (via Telescope)
        vim.keymap.set('n', 'gd',  telescope.lsp_definitions,     utils.with_desc(opts, 'Telescope: Show Definitions'))
        vim.keymap.set('n', 'gi',  telescope.lsp_implementations,  utils.with_desc(opts, 'Telescope: Show LSP Implementations'))
        vim.keymap.set('n', 'gtd', telescope.lsp_type_definitions, utils.with_desc(opts, 'Telescope: Show Type Definitions'))
        vim.keymap.set('n', 'gr',  telescope.lsp_references,       utils.with_desc(opts, 'Telescope: Show References'))
        vim.keymap.set('n', 'K',   vim.lsp.buf.hover,              utils.with_desc(opts, 'LSP: View hover info'))
        vim.keymap.set('n', 'gK',  vim.lsp.buf.hover,              utils.with_desc(opts, 'LSP: View hover info'))
        vim.keymap.set('n', '<leader>fws', vim.lsp.buf.workspace_symbol, utils.with_desc(opts, 'LSP: Find workspace symbol'))

        -- Diagnostics
        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, utils.with_desc(opts, 'LSP: Open diagnostic float'))
        vim.keymap.set('n', '[d',         vim.diagnostic.goto_next,  utils.with_desc(opts, 'LSP: Go to next diagnostic'))
        vim.keymap.set('n', ']d',         vim.diagnostic.goto_prev,  utils.with_desc(opts, 'LSP: Go to previous diagnostic'))

        -- Code actions
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, utils.with_desc(opts, 'LSP: Code actions'))
        vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format,      utils.with_desc(opts, 'LSP: Format buffer'))
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename,      utils.with_desc(opts, 'LSP: Rename symbol'))
        vim.keymap.set('n', '<leader>cc', vim.lsp.codelens.run,    utils.with_desc(opts, 'LSP: Codelens run'))

        -- Omnisharp: override nav keymaps with omnisharp-extended telescope variants
        if client and client.name == 'omnisharp' then
            local ext = require('omnisharp_extended')
            vim.keymap.set('n', 'gd',  ext.telescope_lsp_definition,     opts)
            vim.keymap.set('n', 'gi',  ext.telescope_lsp_implementation,  opts)
            vim.keymap.set('n', 'gtd', ext.telescope_lsp_type_definition, opts)
            vim.keymap.set('n', 'gr',  ext.telescope_lsp_references,      opts)
        end
    end
})

vim.diagnostic.config({
    virtual_text = true,
})
