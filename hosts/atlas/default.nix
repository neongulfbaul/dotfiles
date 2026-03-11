{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix") # Add this
    ../../modules/profiles/hardware/nvidia.nix
    ../../modules/desktop/fonts.nix
    ../../modules/user.nix
    ../../modules/home.nix
    ../../modules/profiles/user/neon.nix
    ../../modules/desktop/apps/jp.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
 
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

  i18n.defaultLocale = "en_AU.UTF-8";
  ## System Toggles
  modules.desktop.fonts.enable = true;
  modules.desktop.apps.jp.enable = true;

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

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["neon"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

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
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;

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

  nixpkgs.config.allowUnfree = true;
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
    git
    wget
    discord
    remmina
    blueman
    betterdiscordctl
    age
    mako
    swaylock-effects
    swayidle
  ];


    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.neon = { pkgs, ... }: {
            imports = [ ../../modules ]; 
            home.stateVersion = "24.11";
            modules = {
                desktop = {
                    hyprland.enable = true;
                    term.foot.enable = true;
                    media.spotify.enable = true;
                    browsers.librewolf.enable = true;
                    apps = {
                        rofi.enable = true;
                        dunst.enable = true;
                        cyber.enable = true;
                    };
                };
                editors.neovim.enable = true;
                shell = {
                    tmux.enable = true;
                    zsh.enable = true;
                    core.enable = true;
                    utils.enable = true;
                };
            };
            home.packages = with pkgs; [
                # Fonts
                ubuntu_font_family
                dejavu_fonts
                adwaita-icon-theme
                font-awesome

                # Terminals / Shell Tools
                fd
                bat
                eza
                fasd
                fzf
                nix-zsh-completions
                ripgrep
                tree
                python312
                pavucontrol

                # Productivity / General Apps
                git
                obsidian
                signal-desktop
                telegram-desktop
                qutebrowser
                remmina
                newsboat
                mpv
                zathura
                jq
                yazi
                nnn
                xfce.thunar
            ];
        };
};
  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
