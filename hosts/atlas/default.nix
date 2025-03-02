{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "atlas";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Hobart";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Add other packages you need here
  services.displayManager.defaultSession = "none+xmonad";

  services.xserver = {
    enable = true;

    windowManager.xmonad = {
      enable = true;
    };

    displayManager.lightdm = {
      enable = true;
      greeter = {
        name = "lightdm-gtk-greeter";
        # Optional greeter settings
      };

    };
  };

  environment.etc."xdg/sessions/xmonad.desktop" = {
    text = ''
      [Desktop Entry]
      Name=XMonad
      Comment=Use the XMonad window manager
      Exec=xmonad
      Type=Application
    '';
    mode = "0644";
  };

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "xmonad";
    services.xrdp.openFirewall = true;
  

    hardware.bluetooth.enable = true; 
    services.blueman.enable = true;



  #services.xserver.enable = true;
  #services.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.xkb = {
    layout = "us";
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.neon = {
    isNormalUser = true;
    description = "neon";
    extraGroups = [ "networkmanager" "wheel" ];
    #packages = with pkgs; [  ];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;
  #programs.lutris.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "neon" ];
  };


  programs.appimage = {
  enable = true;
  binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    lutris
    wineWowPackages.stable
    winetricks
    discord
    remmina
    flameshot
    ghostty
    blueman
    ffmpeg
    betterdiscordctl
        #linuxKernel.packages.linux_5_15.nvidia_x11
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
