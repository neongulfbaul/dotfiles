{ lib, nixvim, ... }
imports = [
    /plugins
    ./options.nix
    ./completions.nix
    ./todo.nix
   ];

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
    };
}
