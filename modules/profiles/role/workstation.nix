# modules/profiles/role/workstation.nix
{ lib, config, pkgs, ... }:
with lib;
mkIf (config.modules.profiles.role == "workstation") {
  # Allow unfree packages on workstations
  nixpkgs.config.allowUnfree = true;

  # Boot optimizations
  boot = {
    loader = {
      systemd-boot.enable = mkDefault true;
      timeout = mkDefault 1;
    };
    initrd.availableKernelModules = [
      "xhci_pci"
      "usb_storage"
      "usbhid"
      "ahci"
      "sd_mod"
    ];
    # Optional: kernel parameters for gaming (uncomment if needed)
    # kernelParams = [ "mitigations=off" ];
    
    kernel.sysctl = {
      # Gaming optimizations
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout" = 5;
      "kernel.split_lock_mitigate" = 0;
      "vm.max_map_count" = 2147483642;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  # Power management - performance for workstations
  powerManagement.cpuFreqGovernor = mkDefault "performance";

  # Networking with systemd
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };
  systemd = {
    network = {
      networks = {
        "30-wired" = {
          enable = true;
          name = "en*";
          networkConfig.DHCP = "yes";
          networkConfig.IPv6PrivacyExtensions = "kernel";
          linkConfig.RequiredForOnline = "no";
          dhcpV4Config.RouteMetric = 1024;
        };
        "30-wireless" = {
          enable = true;
          name = "wl*";
          networkConfig.DHCP = "yes";
          networkConfig.IPv6PrivacyExtensions = "kernel";
          linkConfig.RequiredForOnline = "no";
          dhcpV4Config.RouteMetric = 2048;
        };
      };
      wait-online = {
        anyInterface = true;
        timeout = 30;
        enable = false;
      };
    };
  };
  boot.initrd.systemd.network.wait-online = {
    anyInterface = true;
    timeout = 10;
  };

  # Desktop modules enabled
  modules = {
    desktop.hyprland.enable = true;
    desktop.term.foot.enable = true;
    desktop.browsers.librewolf.enable = true;
    desktop.fonts.enable = true;
  };

  # SSH agent for workstations
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
}
