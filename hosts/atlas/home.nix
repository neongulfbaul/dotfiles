{ pkgs, ... }: {
  home.packages = with pkgs; [ neovim git ];
  home.stateVersion = "24.11";
}
