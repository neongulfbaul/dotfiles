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
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true
vim.opt.guicursor = ""

require("lazy").setup("plugins", {
    rocks = { enabled = false },
    -- Remove this dev section!
    -- dev = {
    --     path = "~/.local/share/nvim/nix",
    --     fallback = false,
    -- }
})
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
        require("user.lsp").setup()
    end,
})
require("user")
