{ self, config, pkgs, nixvim, ... }:

{
  imports = [
    ../../modules/zsh.nix
    ../../modules/nvim.nix
    ../../modules/tmux.nix
    ../../modules/alacritty.nix
    ../../modules/librewolf.nix
    ../../modules/hyprland.nix
    ../../modules/waybar.nix
  ];

  home.username = "neon";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Fonts
    ubuntu_font_family
    dejavu_fonts
    adwaita-icon-theme
    font-awesome

    # Terminals / shell tools
    kitty
    fd
    bat
    bc
    dust
    eza
    fasd
    fzf
    gnumake
    nix-zsh-completions
    ripgrep
    tokei
    ouch
    tree
    unzip
    p7zip
    python312
    libnotify

    # Productivity / general apps
    git
    anki-bin
    obsidian
    signal-desktop
    telegram-desktop
    ranger
    qutebrowser
    calibre
    remmina
    newsboat
    mpv
    rofi

    # Cyber / security
    (burpsuite.override { proEdition = true; })

    # Virtualisation
    quickemu

    # Network tools
    dig
  ];

  xdg = {
    userDirs = {
      enable = false;
    };
  };

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DESKTOP_DIR     = "$HOME";
    XDG_DOWNLOAD_DIR    = "$HOME/downloads";
    XDG_TEMPLATES_DIR   = "$HOME";       
    XDG_PUBLICSHARE_DIR = "$HOME";       
    XDG_DOCUMENTS_DIR   = "$HOME/documents";
    XDG_MUSIC_DIR       = "$HOME";       
    XDG_PICTURES_DIR    = "$HOME/pictures";
    XDG_VIDEOS_DIR      = "$HOME";       
   
    backupFileExtension = "backup";
  };
}
