{ self, config, pkgs, ... }:

{
  imports = [
    ../../modules/shell/zsh.nix 
    ../../modules/editors/nvim.nix
    ];

  home.username = "neon";
  home.stateVersion = "24.11";
  home.file.".zshenv".enable = false;
  home.packages = with pkgs; [
    ubuntu_font_family
    dejavu_fonts
    symbola
    kitty
    git
    cowsay
    anki-bin
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

  # Enable hpyrland in home-manager
  #wayland.windowManager.hyprland.enable = true; 
  #programs.wezterm = {
  #  enable = true;
  #  enableZshIntegration = true;
  #  enableBashIntegration = true;
  #  extraConfig = builtins.readFile ./wezterm.lua;
  #};

  # Enable xmonad
  #xsession.windowManager.xmonad = {
  #  enable = true;
  #  enableContribAndExtras = true;
  #  config = ../../config/xmonad.hs;
  #}; 
  #programs.xmobar = {
  #  enable = true;
  #  extraConfig = builtins.readFile ../../config/xmobar.hs;
  #};

  #home.file.".config/nvim/".source = config.lib.file.mkOutOfStoreSymlink ../../config/nvim;
  #home.file.".config/nvim/".recursive = true;
}
