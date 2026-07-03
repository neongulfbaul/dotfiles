{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    # Replace acceleration = "cuda" with the direct CUDA package
    package = pkgs.ollama-cuda; 
    host = "0.0.0.0";      # Allow external access
  };

  networking.firewall.allowedTCPPorts = [ 11434 ]; # Default Ollama port

  systemd.services.ollama = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
