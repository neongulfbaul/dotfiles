-- 1. Lazy Bootstrap (Keep this for dynamic plugin management)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Your Core Options (Cold Hard Facts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true
vim.opt.guicursor = ""
-- Add these to ensure Nix-managed files are detected
vim.opt.runtimepath:append("/etc/profiles/per-user/" .. vim.env.USER .. "/share/nvim/site")

-- 3. Lazy Plugin Setup
require("lazy").setup("plugins", {
    rocks = { enabled = false },
    -- This ensures Lazy doesn't try to "own" the Treesitter parsers provided by Nix
    performance = {
        rtp = {
            disabled_plugins = {
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
            },
        },
    },
})

-- 4. The Nix Bridge (Re-injecting Nix-managed paths AFTER Lazy setup)
-- This ensures nvim-treesitter.withAllGrammars is visible to Neovim
local nix_plugins = "/etc/profiles/per-user/" .. vim.env.USER .. "/share/nvim/site"
vim.opt.rtp:append(nix_plugins)

-- Load the rest of your user preferences
require("user")
