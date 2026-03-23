-- config/nvim/lua/plugins/lsp.lua
-- We no longer return a table for lazy.nvim here. 
-- We just define the function to be called by init.lua.

local M = {}

function M.setup()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("fidget").setup({})

    -- The most direct way to setup without framework triggers
    require("lspconfig.configs") 
    
    require("lspconfig").nixd.setup({ capabilities = capabilities })
--    require("lspconfig").nil_ls.setup({ capabilities = capabilities })
    require("lspconfig").zls.setup({ 
        capabilities = capabilities,
        settings = { zls = { enable_inlay_hints = true } }
    })

    require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = { globals = { "vim", "bit" } },
            },
        },
    })

    -- Setup CMP
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

return M -- This closes the 'return {}' table
