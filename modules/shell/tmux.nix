# modules/shell/tmux.nix
{ pkgs, lib, config, ... }:
let
  user = config.user.name;
in {
  options.modules.shell.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf config.modules.shell.tmux.enable {
    home-manager.users.${user} = {
      programs.tmux.enable = true;

      xdg.configFile."tmux/tmux.conf".source = ../../config/tmux/tmux.conf;
    };
  };
}
