# modules/profiles/default.nix
{ lib, ... }:
with lib;
let
  mkOpt = type: default: mkOption { inherit type default; };
in
{
  options.modules.profiles = with types; {
    user = mkOpt str "";
    role = mkOpt str "";
    platform = mkOpt str "";
    hardware = mkOpt (listOf str) [];
    networks = mkOpt (listOf str) [];
  };
}
