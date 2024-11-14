{ config, ... }:
{
  environment.etc."zshenv".text = ''
    source /home/neon/.config/zsh/.zshenv
  '';
}
