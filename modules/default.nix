# modules/default.nix
{ ... }: {
  imports = [
    ./user.nix
    ./home.nix
    ./shell
    ./editors
    ./desktop
  ];
}
