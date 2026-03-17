# modules/profiles/user/neon.nix
{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.profiles;
  username = cfg.user;
  role = cfg.role;
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQHUIP2sUhehBXojjy6Kfq6UINn5AU/TJrjYgEvYDeL neon@atlas";
in
mkIf (username == "neon") (mkMerge [
  {
    # Set user attributes - these get aliased to users.users.neon.*
    user = {
      name = username;
      description = "neon";
      uid = 1000;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "libvirtd" ];
      
      packages = with pkgs; [
        # Fonts
        nerd-fonts.blex-mono  # This is "IBM Plex Mono" patched with icons
        noto-fonts-cjk-sans   # Keep this for your Japanese study!
        ubuntu-classic
        dejavu_fonts
        adwaita-icon-theme
        font-awesome
        # Shell tools
        fd bat eza fasd fzf
        nix-zsh-completions
        ripgrep tree
        # Apps
        git obsidian
        signal-desktop
        telegram-desktop
        qutebrowser
        newsboat mpv zathura
        jq yazi nnn
        thunar
        python312
        pavucontrol
      ];
      
      openssh.authorizedKeys.keys = [ key ];
    };
    
    # System-wide settings
    time.timeZone = "Australia/Hobart";
    i18n.defaultLocale = mkDefault "en_AU.UTF-8";
    
    # Root SSH access
    users.users.root.openssh.authorizedKeys.keys = [
      (if role == "workstation"
       then ''from="10.0.0.0/8,192.168.0.0/16" ${key} ${username}''
       else key)
    ];
    
    # Link user packages to home-manager (if you're using it)
    home-manager.users.${username}.home.packages = config.user.packages;
  }
])
