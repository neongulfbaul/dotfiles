# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, home-manager, lib, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
      ../../modules/desktop/x.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Testing to try further eliminate crashes
  boot.kernelParams = [ "i915.enable_guc=0" ];


  # chatgpt suggestion for potential fix for crash - cpu microcode update?
  hardware.cpu.intel.updateMicrocode = true;

  # attempting to get lutris things working with video driver specifics?
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics.enable32Bit = true;
  networking.hostName = "x1"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Hobart";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.supportedLocales = [
    "en_AU.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
    ];
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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
    #services.xserver.displayManager.startx.enable = true;
  # Enable xmonad 
    # services.xserver.windowManager.xmonad = {
    #enable = true;
    #enableContribAndExtras = true;
    #flake = {
    #    enable = true;
    #    compiler = "ghc947";
    #};
    #config = builtins.readFile ../../config/xmonad.hs;
    #enableConfiguredRecompile = true;
    #};

    environment.systemPackages = with pkgs; [
        acpi
        kitty
    ];
  # Enable the GNOME Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #  services.xserver.desktopManager.plasma5.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.neon = {
    isNormalUser = true;
    description = "Nathan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  
  # Instal appimage to use flatpaks
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  
  # Install 1password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "neon" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  programs.zsh.enable = true;
  users.users.neon.shell = pkgs.zsh;

    # environment.etc."zshenv".text = ''
    #source $HOME/.config/zsh/.zshenv
    #'';
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

