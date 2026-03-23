# modules/profiles/roles/vm.nix
{ config, pkgs, lib, ... }:

{
  # Force DHCP for VM networking to ensure internet access for zgenom
  networking.useDHCP = lib.mkForce true;
  networking.interfaces.enp3s0.ipv4.addresses = lib.mkForce [];
  networking.defaultGateway = lib.mkForce null;

  # Define hardware and port forwarding inside the QEMU scope
  virtualisation.qemu = {
    options = [ 
      "-m 2048" 
      "-smp 2" 
    ];
    networkingOptions = [
      "-net nic,model=virtio"
      "-net user,hostfwd=tcp::3000-:3000,hostfwd=tcp::8080-:80,hostfwd=tcp::8222-:80" 
    ];
  };

  # Optional: Enable serial console for easier VM debugging
  boot.kernelParams = [ "console=ttyS0" ];
}
