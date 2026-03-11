# modules/default.nix
{ ... }: {
  imports = [
    ./user.nix
    ./home.nix
    ./xdg.nix
    ./shell
    ./editors
    ./desktop
  ];
}
