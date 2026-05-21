# modules/default.nix
{ ... }: {
  imports = [
    ./security.nix
    ./home.nix
    ./xdg.nix
    ./services
    ./shell
    ./editors
    ./desktop
    ./profiles
  ];
}
