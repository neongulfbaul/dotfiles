return {
  settings = {
    nixd = {
      formatting = {
        command = { "alejandra" }, -- This is the magic "one-line" fixer
      },
      options = {
        -- This helps with Neovim's "Go to definition" for NixOS options
        nixos = {
          expr = '(builtins.getFlake "/home/neon/.dotfiles").nixosConfigurations.atlas.options',
        },
      },
    },
  },
}
