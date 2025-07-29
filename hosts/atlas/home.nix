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
    sops
    age
    telegram-desktop
    kdePackages.dolphin
    ranger
    qutebrowser
    calibre
    cifs-utils

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
# i18n.inputMethod.fcitx5.settings.globalOptions = { };

# If not using Home Manager, you may want to ignore your local config at ~/.config/fcitx5 using the following option.
# i18n.inputMethod.fcitx5.ignoreUserConfig = true;

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
 
    # fix issues with rebuilds not overwriting
    backupFileExtension = "backup";
  };
}
