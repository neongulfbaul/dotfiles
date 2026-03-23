-- config/nvim/lua/plugins/treesitter.lua

local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok then
    ts_configs.setup({
        -- Since Nix handles the binaries, we disable all automatic installation
        ensure_installed = {}, 
        auto_install = false,
        
        highlight = {
            enable = true,
            -- Markdown often looks better with both TS and Regex highlighting
            additional_vim_regex_highlighting = { "markdown" },
        },
        indent = {
            enable = true
        },
    })
end

-- Return empty so lazy.nvim doesn't try to install treesitter via git
return {}
