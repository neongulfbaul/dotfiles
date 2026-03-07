{ pkgs, inputs, lib, config, ... }:

with lib;

{
  options.modules.editors.neovim = {
    enable = lib.mkEnableOption "neovim configuration";
  };

  config = lib.mkIf config.modules.editors.neovim.enable {

  programs.neovim = {
    enable = true;
    #package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaPackages = ps: [
      ps.lua
      ps.luarocks-nix
      ps.magick
    ];
    extraPackages = with pkgs; [
      xclip
      imagemagick
      gcc
      # Language Servers
      # https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      lua-language-server
      nil
      nixd

      # Formatters
      # https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
      black
      nixfmt-rfc-style
      nodePackages.prettier
      biome
      shfmt
      stylelint
      stylua
    ];
  };

  home.file."./.config/nvim/" = {
    source = ../../config/nvim;
    recursive = true;
  };
	
   home.file."./.config/nvim/lua/user/init.lua".text = ''
     require("user.options")
     require("user.keymaps")
      '';
};
}
