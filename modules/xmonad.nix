{ pkgs, home, ... }: {

  xsession.windowManager.xmonad = {
    enable = true;
    extraPackages = haskellPackages: [
      haskellPackages.xmonad-contrib
      haskellPackages.containers
      haskellPackages.xmonad
      haskellPackages.xmobar
      haskellPackages.font-awesome-type
    ];
    enableContribAndExtras = true;
    config = ../config/xmonad/xmonad.hs;
  };
  programs.xmobar.enable = true;

  home.packages = with pkgs; [
    # utils
    acpi # hardware states
    brightnessctl # Control background
    playerctl # Control audio
    jq # parse json

    # rice
    betterlockscreen # ok lockscreen
    dunst # notifications
    feh # background
    picom # Compositor

    # nice
    maim # Screenshot
    rofi # quick start

    alsa-utils
    i3lock
    imagemagick
    spotify
    vlc
    mpv
    feh
    blueman
    pavucontrol
    trayer
    xdg-utils
    sudo

    lm_sensors   # For coreTemp
    wirelesstools # For wireless
    weather # For weather
    xmonad-log # for communication between xmonad and xmobar 

    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts

  ];

    #home.file.".xinitrc".source = ../../config/xinitrc;
}
