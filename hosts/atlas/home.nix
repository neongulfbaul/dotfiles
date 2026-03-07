{ pkgs, ... }:

{
  imports = [
    ../../modules/shell/zsh.nix
    ../../modules/editors/nvim.nix
    ../../modules/desktop/browsers/librewolf.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/media/spotify.nix
    ../../modules/desktop/apps/rofi.nix
    ../../modules/desktop/term/foot.nix
    ../../modules/shell
  ];

  # for good measure, export to session as well
  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
  };

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
    remmina
    newsboat
    mpv
    zathura
    jq
    yazi
    nnn
    xfce.thunar

    # Cyber / security
    (burpsuite.override { proEdition = true; })

    # Virtualisation
    quickemu

    # Network tools
    dig
  ];

  modules.desktop.media.spotify.enable = true;
  modules.desktop.apps.rofi.enable = true;
  modules.desktop.browsers.librewolf.enable = true;
  modules.shell.tmux.enable = true;
  modules.shell.core.enable = true;
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
