-- config/nvim/lua/plugins/treesitter.lua
-- Since we're using Nix-managed treesitter, don't let lazy.nvim manage it
-- Just configure it here
local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok then
    ts_configs.setup({
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "markdown" },
        },
        indent = {
            enable = true
        },
    })
    
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.templ = {
        install_info = {
            url = "https://github.com/vrischmann/tree-sitter-templ.git",
            files = {"src/parser.c", "src/scanner.c"},
            branch = "master",
        },
    }
    vim.treesitter.language.register("templ", "templ")
end

-- Return empty so lazy.nvim doesn't try to manage it
return {}
