# modules/profiles/user/neon.nix
{ pkgs, ... }: {
  user = {
    name     = "neon";
    uid      = 1000;
    timezone = "Australia/Hobart";
    locale   = "en_AU.UTF-8";
    shell    = pkgs.zsh;

    # All your personal packages live here, not scattered in host files
    packages = with pkgs; [
      # Fonts
      ubuntu_font_family
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
      xfce.thunar
      python312
      pavucontrol
    ];
  };
}
