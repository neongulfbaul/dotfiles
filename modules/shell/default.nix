# modules/shell/default.nix
{ ... }: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./git.nix
   #./utils.nix
  ];
}
