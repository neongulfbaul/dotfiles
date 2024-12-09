{ pkgs, inputs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "ubuntu";
    theme = "Rosé Pine";
    shellIntegration.enableZshIntegration = true;
  };

    #  home.file."./.config/tmux/tmux.conf" = {
    #    source = ../../config/tmux/tmux.conf;
    #  };
	
}
