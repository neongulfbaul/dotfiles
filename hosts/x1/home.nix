{ self, config, pkgs, nixvim, ... }:

{
  imports = [
    ../../modules/desktop/xmonad.nix
    ../../modules/shell/zsh.nix
    ../../modules/editors/nvim.nix
    ];

  home.username = "neon";
  home.stateVersion = "24.11";
    #home.file.".zshenv".enable = false;
  home.packages = with pkgs; [
    cargo
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

    # tools used by zsh/shell stuff
    fd
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
    ouch     # a better unzip
    tree

    #jp tools
    lime3ds
    firefox-devedition
    noto-fonts-cjk-sans
    perl540Packages.ImageOCRTesseract
    melonDS
  ];

    #programs.xdg = {
    #enable = true;
    #userDirs.enable = true;
    #};

    
  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";

  # fix issues with rebuilds not overwriting
  backupFileExtension = "backup";
  };
}
