{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.modules.hardware.nvidia;
  # We need to define this here so the rest of the file can see it
  nvidiaPkg = config.boot.kernelPackages.nvidiaPackages.stable;
in {
  options.modules.hardware.nvidia.enable = mkEnableOption "Nvidia GPU support";

  config = mkIf cfg.enable {
    # 1. Hardware & Driver Core
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.libva-vdpau-driver ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      package = nvidiaPkg;
      modesetting.enable = true;
      
      powerManagement.enable = mkDefault true;
      powerManagement.finegrained = mkDefault false;

      open = mkDefault false;
      nvidiaSettings = false; # Use our wrapper instead
      
      # persistenced helps with power/stability.
      #nvidiaPersistenced = true;
    };

    environment = {
      systemPackages = with pkgs; [
        # The "Lissner Special": Wraps nvidia-settings to respect XDG
        (stdenv.mkDerivation {
          name = "nvidia-settings-wrapped";
          buildInputs = [ makeWrapper ];
          buildCommand = ''
            mkdir -p $out/bin
            makeWrapper ${nvidiaPkg.settings}/bin/nvidia-settings $out/bin/nvidia-settings \
              --run 'mkdir -p "$XDG_CONFIG_HOME/nvidia"' \
              --append-flags '--config="$XDG_CONFIG_HOME/nvidia/rc.conf"'
          '';
        })

        cudaPackages.cudatoolkit
        libva
      ];

      variables = {
        CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      };

      sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        #WLR_NO_HARDWARE_CURSORS = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # GBM_BACKEND can stay for now, but comment it out if Firefox/Discord flickers
        #GBM_BACKEND = "nvidia-drm";
      };
    };
  }; 
}
