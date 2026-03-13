# modules/shell/tmux.nix
{ pkgs, lib, config, ... }:
{
  options.modules.shell.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf config.modules.shell.tmux.enable {
    environment.variables = {
      TMUX_TMPDIR = "$XDG_RUNTIME_DIR";
    };

    environment.systemPackages = [ pkgs.tmux ];
    home.configFile."tmux/tmux.conf".source = ../../config/tmux/tmux.conf;
  };
}
