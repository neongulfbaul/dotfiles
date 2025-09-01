{ self, config, pkgs, nixvim, ... }:

{
  imports = [
    ../../modules/xmonad.nix
    ../../modules/zsh.nix
    ../../modules/nvim.nix
    ../../modules/jp.nix
    ../../modules/tmux.nix
    ../../modules/dunst.nix
    ../../modules/alacritty.nix
    ../../modules/librewolf.nix
    ];

  home.username = "neon";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    cargo
    ubuntu_font_family
    dejavu_fonts
    kitty
    git
    anki-bin
    lutris
    wineWowPackages.stable
    winetricks
    adwaita-icon-theme
    remmina
    #firefox-devedition
    obsidian
    signal-desktop
    telegram-desktop
    kdePackages.dolphin
    ranger
    qutebrowser
    calibre
    cifs-utils
    samba
    newsboat

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
    libnotify   
    unzip
    p7zip
    mpv

    # cyber
    (burpsuite.override { proEdition = true; })


    # virtual
    quickemu

    #homelab management
    kubectl
    helmfile
    kustomize
    kubernetes-helm
    k9s
    
    #network tools
    dig
  ];
  
    i18n.inputMethod.fcitx5.settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
            Name = "Default";
            "Default Layout" = "jp";
            DefaultIM = "mozc";
        };
        "Groups/0/Items/0".Name = "keyboard-jp";
        "Groups/0/Items/1".Name = "mozc";
    };
    
    #      programs.cron = {
    #        enable = true;
    #        systemCronJobs = [
    #          "0 7,19 * * * neon pkill calibre; sleep 5; rsync -a --delete /home/neon/documents/calibre ~/mnt/books/"
    #        ];
    #      };

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
    XDG_TEMPLATES_DIR   = "$HOME";       # disables Templates folder
    XDG_PUBLICSHARE_DIR = "$HOME";       # disables Public folder
    XDG_DOCUMENTS_DIR   = "$HOME/documents";
    XDG_MUSIC_DIR       = "$HOME";       # disables Music folder
    XDG_PICTURES_DIR    = "$HOME/pictures";
    XDG_VIDEOS_DIR      = "$HOME";       # disables Videos folder
   
    # fix issues with rebuilds not overwriting
    backupFileExtension = "backup";
  };
}
