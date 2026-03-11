# lib/mkOpt.nix - replaces hey.lib's mkOpt/mkOpt'
{ lib }:
with lib; {
  # mkOpt type default  →  option with no description
  mkOpt  = type: default: mkOption { inherit type default; };

  # mkOpt' type default desc  →  option with description  
  mkOpt' = type: default: description: mkOption { inherit type default description; };
}
