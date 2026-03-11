# modules/editors/nvim.nix
{ pkgs, lib, config, ... }:
let
  user = config.user.name;
in {
  options.modules.editors.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf config.modules.editors.neovim.enable {
    environment.sessionVariables = {
    EDITOR  = "nvim";
    VISUAL  = "nvim";  # worth adding too — some programs use VISUAL
    };

    home-manager.users.${user} = {
      programs.neovim = {
        enable        = true;
        defaultEditor = true;
        viAlias       = true;
        vimAlias      = true;
        extraLuaPackages = ps: [
          ps.lua
          ps.luarocks-nix
          ps.magick
        ];
        extraPackages = with pkgs; [
          xclip
          imagemagick
          gcc
          lua-language-server
          nil
          nixd
          black
          nixfmt-rfc-style
          nodePackages.prettier
          biome
          shfmt
          stylelint
          stylua
        ];
      };

      xdg.configFile."nvim" = {
        source    = ../../config/nvim;
        recursive = true;
      };

      # Generates the init.lua that loads your user modules
      xdg.configFile."nvim/lua/user/init.lua".text = ''
        require("user.options")
        require("user.keymaps")
      '';
    };
  };
}
