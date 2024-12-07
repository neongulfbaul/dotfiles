# Sipping once 🥣, sipping twice 🥣
# Sipping chicken noodle soup with rice.
{ pkgs, home, ... }: {
  #imports = [ ../programs/eww.nix ../programs/polybar.nix ];

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
    config = ../../config/xmonad.hs;
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
    xmonad-log # For XMonadLog (if available in your channel)
    cabal-install

    cabal2nix

    alsa-lib
    openssl
    pkg-config
    xorg.libX11
    xorg.libXext
    xorg.libXft
    xorg.libXpm
    xorg.libXrandr
    xorg.libXScrnSaver
    zlib
    zstd

    pkgs.openssl.dev
    pkgs.zlib.dev
        
    haskell.compiler.ghc98

    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts
    nerd-fonts.hack

  ];

  home.file.".xinitrc".source = ../../config/xinitrc;
}
