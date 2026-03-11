# modules/shell/default.nix
{ ... }: {
  imports = [
    ./zsh.nix
    ./tmux.nix
   #./utils.nix
  ];
}
