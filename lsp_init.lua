-- ~/.config/nvim/lua/plugins/lsp_init.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "j-hui/fidget.nvim",
    },
    config = function()
      -- This calls the 'M.setup()' function from the file you just shared
      require("user.lsp").setup()
    end,
  },

  -- Explicitly disable Lazy's Treesitter so it doesn't fight with Nix
  { "nvim-treesitter/nvim-treesitter", enabled = false },
}
