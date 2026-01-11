{ pkgs, ... }:

{
  imports = [
    ../../modules/zsh.nix
    ../../modules/nvim.nix
    ../../modules/tmux.nix
    ../../modules/librewolf.nix
    ../../modules/hyprland.nix
    ../../modules/waybar.nix
    ../../modules/spotify.nix
    ../../modules/cursor.nix
    ../../modules/rofi.nix
    ../../modules/foot.nix
    ../../modules/mpd.nix
  ];


  # for good measure, export to session as well
  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
  };


    #  programs.foot.settings.colors = nix-colors.colorSchemes.catppuccin-mocha;
    #  programs.zsh.settings.prompt.colors = nix-colors.colorSchemes.catppuccin-mocha;

  home.username = "neon";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Fonts
    ubuntu_font_family
    dejavu_fonts
    adwaita-icon-theme
    font-awesome
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans

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
    pavucontrol
    internetarchive

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
    zathura
    jq
    bottles

    # Cyber / security
    (burpsuite.override { proEdition = true; })

    # Virtualisation
    quickemu

    # Network tools
    dig
  ];




  programs.opencode.enable = true;

  modules.apps.spotify.enable = true;
  modules.desktop.cursor.enable = true;
  modules.rofi.enable = true;
  modules.librewolf.enable = true;
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
