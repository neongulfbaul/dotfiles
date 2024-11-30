{ self, config, pkgs, nixvim, ... }:

{
  imports = [
    ../../modules/desktop/xmonad.nix
    ../../modules/shell/zsh.nix
    ../../modules/editors/nvim.nix
    ../../modules/languages/jp.nix
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
    remmina

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
    python312

    #jp tools
    lime3ds
    firefox-devedition
    melonDS
    desmume
    mecab    # jp text parsing tool to work with yomitan
    imagemagick
    python312Packages.py-desmume 
    (retroarch.override {
      cores = with libretro; [
        desmume
        ];
        })
    python312Packages.manga-ocr

    # ai
    ollama

    # debugger for triyng to text hook manually
    gdb
    bintools
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
