-- ~/.config/nvim/lua/plugins/lsp_init.lua
return {
  {
    "neovim/nvim-lspconfig",
    -- We want this to load early enough to set up the runtimepath
    lazy = false, 
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "j-hui/fidget.nvim",
    },
    config = function()
      -- This triggers your refactored logic in lua/user/lsp.lua
      require("user.lsp").setup()
    end,
  },

  -- Keep this disabled to let Nix handle your parsers
  { "nvim-treesitter/nvim-treesitter", enabled = false },
}
