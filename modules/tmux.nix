
# https://github.com/water-sucks/nixed/blob/main/home/profiles/base/nvim/default.nix
{ pkgs, inputs, ... }:

{
  programs.tmux = {
    enable = true;
  };

  home.file."./.config/tmux/tmux.conf" = {
    source = ../../config/tmux/tmux.conf;
  };
	
}
