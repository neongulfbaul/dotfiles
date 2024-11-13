{ lib, config, pkgs, ... }:
let
  username = "neon";
  homeDirectory = "/home/${username}";
  dotfilesPath = "${homeDirectory}/.dotfiles";
in
{
 # imports = [
 #   ../../modules/shell/zsh.nix
 #   ];

  home.username = "neon";
  home.homeDirectory = "/home/neon";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    zsh
    neovim
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
  home.file.".zshenv" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/zsh/.zshenv";
  };
    };
    "zsh" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.config/zsh";
      recursive = true;
    };
}
