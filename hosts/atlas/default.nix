# hosts/atlas/default.nix
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  # Activate the neon profile
  modules.profiles = {
    user = "neon";
    role = "workstation";
    platform = "x86_64-linux";
  };

  # ── Boot ────────────────────────────────────────────────────────
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
    ];
    supportedFilesystems = [ "cifs" ];
  };

  # ── Networking ──────────────────────────────────────────────────
  networking = {
    hostName = "atlas";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNS = [
          "192.168.1.253"
          "1.1.1.1"
        ];
      };
    };
  };
  # ── Hardware ────────────────────────────────────────────────────
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.xserver.xkb.layout = "us";
  time.hardwareClockInLocalTime = false;
  services.timesyncd.enable = true;
  modules.hardware.nvidia.enable = true;

  # ── Audio ───────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── Printing ────────────────────────────────────────────────────
  services.printing = {
    enable = true;
    browsing = true;
    drivers = [ ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # -- TODO temp fix for build issues
  documentation.enable = false;

  # ── Wayland session ─────────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.hyprland}/bin/Hyprland";
      user = config.user.name;
    };
  };
  security.pam.services.swaylock = { };

  # ── Virtualisation ──────────────────────────────────────────────
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ config.user.name ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # ── Filesystems ─────────────────────────────────────────────────
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  # Enable zRam and remove physical swapDevices
  zramSwap.enable = true;
  swapDevices = [ ];

  # ── System packages ─────────────────────────────────────────────
  # TODO: move these into neon.nix user.packages or dedicated modules
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    wget
    age
    discord
    betterdiscordctl
    remmina
    blueman
    mako
    swaylock-effects
    swayidle
    rsync
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ config.user.name ];
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.openssh.enable = true;

  modules = {
    xdg.enable = true;
    editors.neovim.enable = true;
    shell = {
      zsh.enable = true;
      tmux.enable = true;
      git.enable = true;
      gnupg.enable = true;
    };
    desktop = {
      hyprland.enable = true;
      apps.rofi.enable = true;
      term.foot.enable = true;
      browsers.librewolf.enable = true;
      fonts.enable = true;
      apps.chess.enable = true;
    };
  };
}
