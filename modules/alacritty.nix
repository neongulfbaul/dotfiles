{config, lib, pkgs, ...} :

{
  programs.alacritty = {
    enable = true;
    settings = {
        terminal.shell = {
        args = ["new-session"  "-A"  "-D" "-s" "main"];
        program = "${pkgs.tmux}/bin/tmux";
      };
    };
}
