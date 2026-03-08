{ config, lib, pkgs, ... }:

let
  cfg = config.modules.profiles.user;
  # Replace with your actual public key
  pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... (your key) ...";
in
{
  options.modules.profiles.user = {
    enable = lib.mkEnableOption "neon's user profile";
    role = lib.mkOption {
      type = lib.types.enum [ "workstation" "server" ];
      default = "workstation";
    };
  };

  config = lib.mkIf cfg.enable {
    # System-level user identity
    users.users.neon = {
      isNormalUser = true;
      description = "neon";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      shell = pkgs.zsh; # The fix for your default shell issue!
      openssh.authorizedKeys.keys = [ pubKey ];
    };

    # Lissner-style restrictive root access
    users.users.root.openssh.authorizedKeys.keys = [
      (if cfg.role == "workstation"
       then ''from="10.0.0.0/8,192.168.1.0/24" ${pubKey}''
       else pubKey)
    ];

    # Regional settings
    i18n.defaultLocale = "en_AU.UTF-8";
    time.timeZone = "Australia/Hobart"; # Matches your current locale
      
    # Set your XDG state here
    home.stateVersion = "23.11"; 
    };
  };
}
