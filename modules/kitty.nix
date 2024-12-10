{ pkgs, inputs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "ubuntu";
    themeFile = "rose-pine";
    shellIntegration.enableZshIntegration = true;
  };

    #  home.file."./.config/tmux/tmux.conf" = {
    #    source = ../../config/tmux/tmux.conf;
    #  };
	
}
