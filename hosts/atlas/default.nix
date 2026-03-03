{ config, pkgs, home-manager, ... }:

{
  imports = [
    ./nvidia.nix
    ./ollama.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "atlas";
  networking.networkmanager.enable = true;
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=192.168.1.253
      FallbackDNS=1.1.1.1
      DNSStubListener=no
    '';
  };

  time.hardwareClockInLocalTime = false;
  time.timeZone = "Australia/Hobart";
  services.timesyncd.enable = true;

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

  fonts.fontconfig.enable = true;
  fonts.fontconfig.hinting.enable = true;
  fonts.fontconfig.hinting.style = "slight";
  fonts.fontconfig.antialias = true;
  fonts.fontconfig.subpixel.rgba = "rgb";

  environment.shells = with pkgs; [ zsh ];
  boot.supportedFilesystems = [ "cifs" ];

  # Wayland session
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.hyprland}/bin/Hyprland";
      user = "neon";
    };
  };

  security.pam.services.swaylock = {};

  # Virtualisation
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["neon"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

# --- HARDWARE SECTION (The old hardware-configuration.nix) ---
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableHardware;

  # Hardware
  hardware.bluetooth.enable = true; 
  services.blueman.enable = true;

  services.xserver.xkb.layout = "us";

  services.printing = {
    enable = true;
    drivers = [ ]; # leave empty unless you need Brother-specific drivers
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  services.printing.browsing = true;

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
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
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
    zsh
    age
    wl-clipboard
    waybar
    mako
    swaylock-effects
    swayidle
    wofi
    st
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
