# modules/default.nix
{ ... }: {
  imports = [
    ./security.nix
    ./home.nix
    ./xdg.nix
    ./shell
    ./editors
    ./desktop
    ./profiles
  ];
}
