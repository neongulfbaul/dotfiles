{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = "cuda"; # Enable NVIDIA GPU support
    host = "0.0.0.0";      # Allow external access
  };

  networking.firewall.allowedTCPPorts = [ 11434 ]; # Default Ollama port

  systemd.services.ollama = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
