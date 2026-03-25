local M = {}

function M.setup()
    -- 1. Setup UI & Capabilities
    require("fidget").setup({})
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- 2. Global LSP Configuration
    -- This replaces passing 'capabilities' to every single server setup.
    vim.lsp.config("*", {
        capabilities = capabilities,
    })

    -- 3. Initialize lspconfig (Adds its server definitions to the RTP)
    -- This is required so Neovim knows where to find nixd, zls, etc.
    require("lspconfig")

    -- 4. Enable your servers
    -- This replaces the individual .setup() calls.
    vim.lsp.enable({ "nixd", "zls", "lua_ls" })

    -- 5. Setup CMP (Remains mostly the same)
    local cmp = require('cmp')
    cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } }, { { name = 'buffer' } })
    })

    vim.diagnostic.config({ float = { border = "single" } })
end

return M
