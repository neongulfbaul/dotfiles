{ pkgs, lib, inputs, config, ... }:

with lib;

{
  options.modules.shell.tmux = {
    enable = mkEnableOption "Enable tmux";
  };

  config = mkIf config.modules.shell.tmux.enable {

        programs.tmux = {
            enable = true;
        };

        home.file."./.config/tmux/tmux.conf" = {
            source = ../../config/tmux/tmux.conf;
        };
    };
	
}
