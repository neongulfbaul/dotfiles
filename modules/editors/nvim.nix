{ pkgs, ... }:

{

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      xclip
      wl-clipboard
      curl
      gcc
    ];

    plugins = with pkgs.vimPlugins; [
    ];
    extraLuaConfig = ''
    '';

  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = ../../config/nvim;
  };
}
