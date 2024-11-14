{ lib, config, pkgs, dotfiles, ... }:

{
  imports = [
    ../../modules/shell/zsh.nix 
    ../../modules/editors/nvim.nix
    ];

  home.username = "neon";
  home.stateVersion = "24.11";
  home.file.".zshenv".enable = false;
  home.packages = with pkgs; [
    git
    cowsay
    anki-bin
    discord #testing to see if this was causing hang
    lutris
    wineWowPackages.stable
    winetricks
    tree

    # tools used by zsh/shell stuff
    at
    bat      # a better cat
    bc
    dust     # a better du
    eza      # a better ls
    fasd
    fd
    fzf
    gnumake
    nix-zsh-completions
    ripgrep  # a better grep
    tokei    # for code statistics
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = "${dotfiles}/xmonad.hs";
  };

  programs.xmobar = {
    enable = true;
    extraConfig = builtins.readFile "${dotfiles}/xmobar.hs";
  };

  #home.file.".config/nvim/".source = config.lib.file.mkOutOfStoreSymlink ../../config/nvim;
  #home.file.".config/nvim/".recursive = true;
}
