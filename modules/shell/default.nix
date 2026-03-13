# modules/shell/default.nix
{ ... }: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./git.nix
    ./gnupg.nix
   #./utils.nix
  ];
}
